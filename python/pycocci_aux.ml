(*
 * This file is part of Coccinelle, licensed under the terms of the GPL v2.
 * See copyright.txt in the Coccinelle source code for more information.
 * The Coccinelle source code can be obtained at https://coccinelle.gitlabpages.inria.fr/website
 *)

open Ast_c
open Common

let caller s f a =
  let str = ref ([] : string list) in
  let pr_elem info = str := (Ast_c.str_of_info info) :: !str in
  let pr_sp _ = () in
  f ~pr_elem ~pr_space:pr_sp a; 
  String.concat s (List.rev !str)

let callernl s f a =
  let str = ref ([] : string list) in
  let pr_elem info = str := (Ast_c.str_of_info info) :: !str in
  let pr_nl _ = str := "\n" :: !str in
  let pr_sp _ = () in
  f ~pr_elem ~pr_space:pr_sp ~pr_nl a;
  String.concat s (List.rev !str)

let call_pretty f a = caller " " f a
let call_pretty0 f a = caller "" f a
let call_pretty_nl f a = callernl " " f a

let exprrep = call_pretty Pretty_print_c.pp_expression_gen

let commalistrep list_printer elem_printer comma_printer x =
  (call_pretty list_printer x,
   List.map
     (function x ->
       call_pretty elem_printer (comma_printer x) (* drop commas *))
     x)

let exprlistrep =
  commalistrep Pretty_print_c.pp_arg_list_gen Pretty_print_c.pp_arg_gen
    Ast_c.unwrap

let paramlistrep =
  commalistrep Pretty_print_c.pp_param_list_gen Pretty_print_c.pp_param_gen
    Ast_c.unwrap

let initlistrep (newlines,inits) =
  (call_pretty Pretty_print_c.pp_init_list_gen (newlines,inits),
   List.map
     (function x ->
       call_pretty Pretty_print_c.pp_init_gen (Ast_c.unwrap x) (* drop commas *))
     inits)

let fieldlistrep =
  commalistrep Pretty_print_c.pp_field_list_gen Pretty_print_c.pp_field_gen
    (function x -> x)

let stringrep = function
  Ast_c.MetaIdVal        s -> Printf.sprintf "MetaIdVal %s" s
| Ast_c.MetaAssignOpVal op -> call_pretty Pretty_print_c.pp_assignOp_gen op (* todo *)
| Ast_c.MetaBinaryOpVal op -> call_pretty Pretty_print_c.pp_binaryOp_gen op (* todo *)
| Ast_c.MetaPragmaInfoVal v -> Ast_c.str_of_info v (* todo *)
| Ast_c.MetaFuncVal      s -> Printf.sprintf "MetaFuncVal %s" s
| Ast_c.MetaLocalFuncVal s -> Printf.sprintf "MetaLocalFuncVal %s" s
| Ast_c.MetaExprVal      (_,expr,_,_) ->
    Printf.sprintf "MetaExprVal(_,%s,_,_)" (Pretty_print_c.pp_expression_new_simple expr)
| Ast_c.MetaExprListVal  (_,expr_list) ->(* todo *)
    call_pretty Pretty_print_c.pp_arg_list_gen expr_list
| Ast_c.MetaTypeVal      (_,typ) -> call_pretty Pretty_print_c.pp_type_gen typ(* todo *)
| Ast_c.MetaInitVal      (_,ini) -> call_pretty Pretty_print_c.pp_init_gen ini(* todo *)
| Ast_c.MetaInitListVal  (newlines,_,ini) ->(* todo *)
    call_pretty Pretty_print_c.pp_init_list_gen (newlines,ini)
| Ast_c.MetaDeclVal      (_,decl) -> (* todo *)
    Printf.sprintf "MetaDeclVal(_,%s)" "(Pretty_print_c.pp_decl_gen_new decl)"
| Ast_c.MetaFieldVal      (_,field) -> (* todo *)
    call_pretty Pretty_print_c.pp_field_gen field
| Ast_c.MetaFieldListVal      (_,field) ->(* todo *)
    call_pretty Pretty_print_c.pp_field_list_gen field
| Ast_c.MetaStmtVal      (_,statement,_) ->(* todo *)
    call_pretty Pretty_print_c.pp_statement_gen statement
| Ast_c.MetaStmtListVal  (_,statxs,_) ->(* todo *)
    call_pretty_nl Pretty_print_c.pp_statement_seq_list_gen statxs
| Ast_c.MetaParamVal     (_,param) ->(* todo *)
    call_pretty Pretty_print_c.pp_param_gen param
| Ast_c.MetaParamListVal (_,params) ->(* todo *)
    call_pretty Pretty_print_c.pp_param_list_gen params
| Ast_c.MetaTemplateParamVal     (_,param) ->(* todo *)
    call_pretty Pretty_print_c.pp_template_param_gen param
| Ast_c.MetaTemplateParamListVal (_,params) ->(* todo *)
    call_pretty Pretty_print_c.pp_template_param_list_gen params
| Ast_c.MetaDParamListVal params ->(* todo *)
    call_pretty Pretty_print_c.pp_define_param_list_gen params
| Ast_c.MetaFragListVal frags ->(* todo *)
    call_pretty0 Pretty_print_c.pp_string_fragment_list_gen frags
| Ast_c.MetaFmtVal fmt ->(* todo *)
    call_pretty0 Pretty_print_c.pp_string_format_gen fmt
| Ast_c.MetaAttrArgVal (_,name) ->(* todo *)
    call_pretty0 Pretty_print_c.pp_attr_arg_gen name
| Ast_c.MetaListlenVal n -> string_of_int n(* todo *)
| Ast_c.MetaPosVal (pos1, pos2) ->(* todo *)
    let print_pos = function
	Ast_cocci.Real x -> string_of_int x
      | Ast_cocci.Virt(x,off) -> Printf.sprintf "%d+%d" x off in
    Printf.sprintf ("pos(%s,%s)") (print_pos pos1) (print_pos pos2)
| Ast_c.MetaPosValList positions -> "TODO: <<postvallist>>"
| Ast_c.MetaComValList _ -> "TODO: <<postvallist>>"
| Ast_c.MetaNoVal -> failwith "no value, should not occur"
