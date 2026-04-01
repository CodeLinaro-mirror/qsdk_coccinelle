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
  Ast_c.MetaIdVal        s -> Printf.sprintf "MetaIdVal(%s)" s
| Ast_c.MetaAssignOpVal op -> Printf.sprintf "MetaAssignOpVal(%s)" (Pretty_print_c.pr_assignOp_new op)
| Ast_c.MetaBinaryOpVal op -> Printf.sprintf "MetaBinaryOpVal(%s)" (Pretty_print_c.pr_binaryOp_new op)
| Ast_c.MetaPragmaInfoVal v -> Printf.sprintf "MetaPragmaInfoVal(%s)" (Ast_c.str_of_info v)
| Ast_c.MetaFuncVal      s -> Printf.sprintf "MetaFuncVal(%s)" s
| Ast_c.MetaLocalFuncVal s -> Printf.sprintf "MetaLocalFuncVal(%s)" s
| Ast_c.MetaExprVal      (_,expr,_,_) -> Printf.sprintf "MetaExprVal(_,%s,_,_)" (Pretty_print_c.pp_expression_new expr)
| Ast_c.MetaExprListVal  (_,expr_list) -> Printf.sprintf "MetaExprListVal(_,%s)" (Pretty_print_c.pp_arg_list_new expr_list)
| Ast_c.MetaTypeVal      (_,typ) -> Printf.sprintf "MetaTypeVal(_,%s)" (Pretty_print_c.pp_fullType_new typ)
| Ast_c.MetaInitVal      (_,ini) -> Printf.sprintf "MetaInitVal(_,%s)" (Pretty_print_c.pp_init_new ini)
| Ast_c.MetaInitListVal  (newlines,_,ini) -> Printf.sprintf "MetaInitListVal(%s,_,%s)" (Pretty_print_c.pp_newlines_new newlines) (Pretty_print_c.pp_init_list_new ini)
| Ast_c.MetaDeclVal      (_,decl) -> Printf.sprintf "MetaDeclVal(_,%s)" (Pretty_print_c.pp_decl_new decl)
| Ast_c.MetaFieldVal      (_,field) -> Printf.sprintf "MetaFieldVal(_,%s)" (Pretty_print_c.pp_field_new field)
| Ast_c.MetaFieldListVal      (_,field) -> Printf.sprintf "MetaFieldListVal(_,%s)" (Pretty_print_c.pp_field_list_new field)
| Ast_c.MetaStmtVal      (_,statement,_) -> Printf.sprintf "MetaStmtVal(_,%s,_)"    (Pretty_print_c.pp_statement_new statement)
| Ast_c.MetaStmtListVal  (_,statxs,_) -> Printf.sprintf "MetaStmtListVal(_,%s,_)"     (Pretty_print_c.pp_statement_seq_list_new statxs)
| Ast_c.MetaParamVal     (_,param) -> Printf.sprintf "MetaParamVal(_,%s)"     (Pretty_print_c.pp_param_new param)
| Ast_c.MetaParamListVal (_,params) -> Printf.sprintf "MetaParamListVal(_,%s)"     (Pretty_print_c.pp_param_list_new params)
| Ast_c.MetaTemplateParamVal     (_,param) -> Printf.sprintf "MetaTemplateParamVal(_,%s)"     (Pretty_print_c.pp_template_param_new param)
| Ast_c.MetaTemplateParamListVal (_,params) -> Printf.sprintf "MetaTemplateParamListVal(_,%s)"     (Pretty_print_c.pp_template_param_list_new params)
| Ast_c.MetaDParamListVal params -> Printf.sprintf "MetaDParamListVal(%s)"     (Pretty_print_c.pp_define_param_list_new params)
| Ast_c.MetaFragListVal frags -> Printf.sprintf "MetaFragListVal(%s)"     (Pretty_print_c.pp_string_fragment_list_new frags)
| Ast_c.MetaFmtVal fmt -> Printf.sprintf "MetaFmtVal(%s)"     (Pretty_print_c.pp_string_format_new fmt)
| Ast_c.MetaAttrArgVal (_,name) -> Printf.sprintf "MetaAttrArgVal(_,%s)"     (Pretty_print_c.pp_attr_arg_new name)
| Ast_c.MetaListlenVal n -> Printf.sprintf "MetaListlenVal(%i)" n
| Ast_c.MetaPosVal (pos1, pos2) ->
    let print_pos = function
      Ast_cocci.Real x -> string_of_int x
      | Ast_cocci.Virt(x,off) -> Printf.sprintf "%d+%d" x off in
    Printf.sprintf ("MetaPosVal(%s,%s)") (print_pos pos1) (print_pos pos2)
| Ast_c.MetaPosValList positions -> "TODO: <<postvallist>>"
| Ast_c.MetaComValList _ -> "TODO: <<postvallist>>"
| Ast_c.MetaNoVal -> failwith "no value, should not occur"
