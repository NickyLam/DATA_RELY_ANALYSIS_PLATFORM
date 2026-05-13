create or replace force view rrp_mdl.xzy_dep_obj as
select "OWNER","NAME","TYPE","REFERENCED_OWNER","REFERENCED_NAME","REFERENCED_TYPE","REFERENCED_LINK_NAME","DEPENDENCY_TYPE"
  from all_dependencies
 where owner IN ('RRP_MDL','RRP_IND','RRP_IMAS','RRP_BFD','RRP_EAST',
                             'RRP_DIIS','RRP_CRRS','RRP_CAP','RRP_BSSDEV',
                             'ICL','IDL','IEL','IML','IOL','ITL','FDW','RRP_MRPT')
   AND REFERENCED_OWNER NOT IN ('SYS','PUBLIC','FDW','RDW');

