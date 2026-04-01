type type_with_ident = Ast_c.fullType -> (unit -> unit) -> unit
type type_with_ident_rest = Ast_c.fullType -> (unit -> unit) -> unit

type 'a printer = 'a -> unit

type pretty_printers = {
  expression      : Ast_c.expression printer;
  assignOp        : Ast_c.assignOp printer;
  binaryOp        : Ast_c.binaryOp printer;
  arg_list        : (Ast_c.argument Ast_c.wrap2 list) printer;
  arg             : Ast_c.argument printer;
  statement       : Ast_c.statement printer;
  statement_seq_list : Ast_c.statement_sequencable list printer;
  decl            : Ast_c.declaration printer;
  field           : Ast_c.field printer;
  field_list      : Ast_c.field list printer;
  init            : Ast_c.initialiser printer;
  init_list       : (Ast_c.newlines * Ast_c.initialiser Ast_c.wrap2 list) printer;
  param           : Ast_c.parameterType printer;
  paramlist       : (Ast_c.parameterType Ast_c.wrap2 list) printer;
  template_param  : Ast_c.templateParameterType printer;
  template_paramlist : (Ast_c.templateParameterType Ast_c.wrap2 list) printer;
  dparamlist      : ((string Ast_c.wrap) Ast_c.wrap2 list) printer;
  ty              : Ast_c.fullType printer;
  type_with_ident : type_with_ident;
  base_type       : Ast_c.fullType printer;
  type_with_ident_rest : type_with_ident_rest;
  toplevel        : Ast_c.toplevel printer;
  fragment        : Ast_c.string_fragment printer;
  fragment_list   : (Ast_c.string_fragment list) printer;
  format          : Ast_c.string_format printer;
  attribute       : Ast_c.attribute printer;
  attr_arg        : Ast_c.attr_arg printer;
  flow            : Control_flow_c.node printer;
  name            : Ast_c.name printer;
  expression_new  : Ast_c.expression -> string;
  decl_new        : Ast_c.declaration -> string;
  assignOp_new:              Ast_c.assignOp -> string;
  binaryOp_new:              Ast_c.binaryOp -> string;
  arg_list_new:              Ast_c.argument Ast_c.wrap2 list -> string;
  type_new:                  Ast_c.fullType -> string;
  init_new:                  Ast_c.initialiser -> string;
  newlines_new:              Ast_c.newlines -> string;
  init_list_new:             Ast_c.initialiser Ast_c.wrap2 list -> string;
  field_new:                 Ast_c.field -> string;
  field_list_new:            Ast_c.field list -> string;
  statement_new:             Ast_c.statement -> string;
  statement_seq_list_new:    Ast_c.statement_sequencable list -> string;
  param_new:                 Ast_c.parameterType -> string;
  param_list_new:            (Ast_c.parameterType Ast_c.wrap2 list) -> string;
  template_param_new:        Ast_c.templateParameterType -> string;
  template_param_list_new:   (Ast_c.templateParameterType Ast_c.wrap2 list) -> string;
  define_param_list_new:     ((string Ast_c.wrap) Ast_c.wrap2 list) -> string;
  string_fragment_list_new:  Ast_c.string_fragment list -> string;
  string_format_new:         Ast_c.string_format -> string;
  attr_arg_new:              Ast_c.attr_arg -> string;
}

val mk_pretty_printers :
  pr_elem:Ast_c.info printer ->
  pr_space:unit printer ->
  pr_nl: unit printer ->
  pr_indent: unit printer ->
  pr_outdent: unit printer ->
  pr_unindent: unit printer ->
  pretty_printers

(* used in pycocci mostly *)
val pp_expression_gen: pr_elem:Ast_c.info printer -> pr_space: unit printer ->
  Ast_c.expression printer
val pp_assignOp_gen: pr_elem:Ast_c.info printer -> pr_space: unit printer ->
  Ast_c.assignOp printer
val pp_binaryOp_gen: pr_elem:Ast_c.info printer -> pr_space: unit printer ->
  Ast_c.binaryOp printer
val pp_arg_list_gen: pr_elem:Ast_c.info printer -> pr_space: unit printer ->
  (Ast_c.argument Ast_c.wrap2 list) printer
val pp_arg_gen: pr_elem:Ast_c.info printer -> pr_space: unit printer ->
  Ast_c.argument printer
val pp_decl_gen: pr_elem:Ast_c.info printer -> pr_space: unit printer ->
  Ast_c.declaration printer
val pp_field_gen: pr_elem:Ast_c.info printer -> pr_space: unit printer ->
  Ast_c.field printer
val pp_field_list_gen: pr_elem:Ast_c.info printer -> pr_space: unit printer ->
  Ast_c.field list printer
val pp_statement_gen: pr_elem:Ast_c.info printer -> pr_space: unit printer ->
  Ast_c.statement printer
val pp_statement_seq_list_gen:
    pr_elem:Ast_c.info printer -> pr_space: unit printer -> pr_nl: unit printer ->
      Ast_c.statement_sequencable list printer
val pp_param_gen:  pr_elem:Ast_c.info printer -> pr_space: unit printer ->
  Ast_c.parameterType printer
val pp_param_list_gen:  pr_elem:Ast_c.info printer -> pr_space: unit printer ->
  (Ast_c.parameterType Ast_c.wrap2 list) printer
val pp_template_param_gen:  pr_elem:Ast_c.info printer -> pr_space: unit printer ->
  Ast_c.templateParameterType printer
val pp_template_param_list_gen:  pr_elem:Ast_c.info printer -> pr_space: unit printer ->
  (Ast_c.templateParameterType Ast_c.wrap2 list) printer
val pp_define_param_list_gen:
    pr_elem:Ast_c.info printer -> pr_space: unit printer ->
      ((string Ast_c.wrap) Ast_c.wrap2 list) printer
val pp_type_gen:  pr_elem:Ast_c.info printer -> pr_space:unit printer ->
  Ast_c.fullType printer
val pp_init_gen:  pr_elem:Ast_c.info printer -> pr_space:unit printer ->
  Ast_c.initialiser printer
val pp_init_list_gen:  pr_elem:Ast_c.info printer -> pr_space:unit printer ->
  (Ast_c.newlines * Ast_c.initialiser Ast_c.wrap2 list) printer
val pp_string_fragment_list_gen:
    pr_elem:Ast_c.info printer -> pr_space:unit printer ->
      Ast_c.string_fragment list printer
val pp_string_format_gen:
    pr_elem:Ast_c.info printer -> pr_space:unit printer ->
      Ast_c.string_format printer
val pp_attr_arg_gen:
    pr_elem:Ast_c.info printer -> pr_space:unit printer ->
      Ast_c.attr_arg printer
val pp_program_gen : pr_elem:Ast_c.info printer -> pr_space:unit printer ->
  Ast_c.toplevel printer


(* used in pretty_print_engine.ml mostly *)
val pp_expression_simple: Ast_c.expression printer
val pp_arg_list_simple: Ast_c.argument Ast_c.wrap2 list printer
val pp_assignOp_simple: Ast_c.assignOp printer
val pp_binaryOp_simple: Ast_c.binaryOp printer
val pp_init_simple:       Ast_c.initialiser printer
val pp_type_simple:       Ast_c.fullType printer
val pp_decl_simple:       Ast_c.declaration printer
val pp_field_simple:      Ast_c.field printer
val pp_statement_simple:  Ast_c.statement printer
val pp_statement_seq_list_simple: Ast_c.statement_sequencable list printer
val pp_toplevel_simple:   Ast_c.toplevel printer
val pp_string_fragment_simple:   Ast_c.string_fragment printer
val pp_string_format_simple:     Ast_c.string_format printer
val pp_attribute_simple:     Ast_c.attribute printer
val pp_attr_arg_simple:     Ast_c.attr_arg printer

(* alternate pretty printers, used in pycocci_aux TODO *)
val pp_expression_new:     Ast_c.expression -> string
val pp_decl_new:                  Ast_c.declaration -> string
val pr_assignOp_new:              Ast_c.assignOp -> string
val pr_binaryOp_new:              Ast_c.binaryOp -> string
val pp_arg_list_new:              Ast_c.argument Ast_c.wrap2 list -> string
val pp_fullType_new:              Ast_c.fullType -> string
val pp_init_new:                  Ast_c.initialiser -> string
val pp_newlines_new:              Ast_c.newlines -> string
val pp_init_list_new:             Ast_c.initialiser Ast_c.wrap2 list -> string
val pp_field_new:                 Ast_c.field -> string
val pp_field_list_new:            Ast_c.field list -> string
val pp_statement_new:             Ast_c.statement -> string
val pp_statement_seq_list_new:    Ast_c.statement_sequencable list -> string
val pp_param_new:                 Ast_c.parameterType -> string
val pp_param_list_new:            (Ast_c.parameterType Ast_c.wrap2 list) -> string
val pp_template_param_new:        Ast_c.templateParameterType -> string
val pp_template_param_list_new:   (Ast_c.templateParameterType Ast_c.wrap2 list) -> string
val pp_define_param_list_new:     ((string Ast_c.wrap) Ast_c.wrap2 list) -> string
val pp_string_fragment_list_new:  Ast_c.string_fragment list -> string
val pp_string_format_new:         Ast_c.string_format -> string
val pp_attr_arg_new:              Ast_c.attr_arg -> string

val debug_info_of_node:
  Control_flow_c.G.key -> Control_flow_c.cflow -> string

val string_of_expression: Ast_c.expression -> string
(* Normalized string representation of an [Ifdef] guard.
 *
 * Ignored #if conditions (cf. [Gnone]) are treated as 0, which is consistent
 * with the way Coccinelle handles them.
 *
 * @author Iago Abal
 *)
val string_of_ifdef_guard: Ast_c.ifdef_guard -> string
val string_of_flow: Control_flow_c.node -> string
val string_of_fullType: Ast_c.fullType -> string