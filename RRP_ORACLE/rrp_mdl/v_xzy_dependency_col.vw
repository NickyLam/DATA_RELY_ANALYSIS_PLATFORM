create or replace force view rrp_mdl.v_xzy_dependency_col as
select d.u_name owner
     , d.o_name name
     , decode ( d.o_type#
     , 0, 'NEXT OBJECT', 1, 'INDEX', 2, 'TABLE', 3, 'CLUSTER'
     , 4, 'VIEW', 5, 'SYNONYM', 6, 'SEQUENCE', 7, 'PROCEDURE'
     , 8, 'FUNCTION', 9, 'PACKAGE', 10, 'NON-EXISTENT'
     , 11, 'PACKAGE BODY', 12, 'TRIGGER'
     , 13, 'TYPE', 14, 'TYPE BODY', 22, 'LIBRARY'
     , 28, 'JAVA SOURCE', 29, 'JAVA CLASS'
     , 32, 'INDEXTYPE', 33, 'OPERATOR'
     , 42, 'MATERIALIZED VIEW', 43, 'DIMENSION'
     , 46, 'RULE SET', 55, 'XML SCHEMA', 56, 'JAVA DATA'
     , 59, 'RULE', 62, 'EVALUATION CONTXT'
     , 92, 'CUBE DIMENSION', 93, 'CUBE'
     , 94, 'MEASURE FOLDER', 95, 'CUBE BUILD PROCESS'
     , 'UNDEFINED'  ) type
     , nvl2( d.po_linkname, d.po_remoteowner, d.pu_name) referenced_owner
     , d.po_name referenced_name
     , decode  ( d.po_type#
     , 0, 'NEXT OBJECT', 1, 'INDEX', 2, 'TABLE', 3, 'CLUSTER'
     , 4, 'VIEW', 5, 'SYNONYM', 6, 'SEQUENCE', 7, 'PROCEDURE'
     , 8, 'FUNCTION', 9, 'PACKAGE', 10, 'NON-EXISTENT'
     , 11, 'PACKAGE BODY', 12, 'TRIGGER'
     , 13, 'TYPE', 14, 'TYPE BODY', 22, 'LIBRARY'
     , 28, 'JAVA SOURCE', 29, 'JAVA CLASS'
     , 32, 'INDEXTYPE', 33, 'OPERATOR'
     , 42, 'MATERIALIZED VIEW', 43, 'DIMENSION'
     , 46, 'RULE SET', 55, 'XML SCHEMA', 56, 'JAVA DATA'
     , 59, 'RULE', 62, 'EVALUATION CONTXT'
     , 92, 'CUBE DIMENSION', 93, 'CUBE'
     , 94, 'MEASURE FOLDER', 95, 'CUBE BUILD PROCESS'
     , 'UNDEFINED' ) referenced_type
     , d.po_linkname referenced_link_name
     , c.name referenced_column
     , decode(bitand(d.d_property, 3), 2, 'REF', 'HARD') dependency_type
from ( select obj#
            , u_name
            , o_name
            , o_type#
            , pu_name
            , po_name
            , po_type#
            , po_remoteowner
            , po_linkname
            , d_property
            , colpos
         from sys."_CURRENT_EDITION_OBJ" o
            , sys.disk_and_fixed_objects po
            , sys.dependency$ d
            , all_users u
            , all_users pu
        where o.obj# = d.d_obj#
          and o.owner# = u.user_id
          and po.obj# = d.p_obj#
          and po.owner# = pu.user_id
          and d.d_attrs is not null
          and u.username in ('RRP_MDL','RRP_IND','RRP_IMAS','RRP_BFD','RRP_EAST',
                             'RRP_DIIS','RRP_CRRS','RRP_CAP','RRP_BSSDEV',
                             'ICL','IDL','IEL','IML','IOL','ITL','FDW','RRP_MRPT','RRP_YBT')
model
return updated rows
partition by
( po.obj# obj#
, u.username u_name
, o.name o_name
, o.type# o_type#
, po.linkname po_linkname
, pu.username pu_name
, po.remoteowner po_remoteowner
, po.name po_name
, po.type# po_type#
, d.property d_property
)
dimension by (0 i)
measures (0 colpos, substr(d.d_attrs,9) attrs)
rules iterate (1000)
until (iteration_number = 4 * length(attrs[0]) - 2)
( colpos[iteration_number+1] =
  case bitand
  (to_number(substr(attrs[0],1+2*trunc((iteration_number+1)/8),2),'XX'),power(2,mod(iteration_number+1,8)))
       when 0 then null
       else iteration_number+1
   end
)
) d
, sys.col$ c
where d.obj# = c.obj#
  and d.colpos = c.col#;

