/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ifms_tbissamt
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ifms_tbissamt
whenever sqlerror continue none;
drop table ${iol_schema}.ifms_tbissamt purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ifms_tbissamt(
    prd_code varchar2(32) -- 
    ,branch_no varchar2(24) -- 
    ,internal_branch varchar2(18) -- 
    ,totsale_amt number(18,2) -- 
    ,person_amt number(18,2) -- 
    ,sale_pamt number(18,2) -- 
    ,allot_pamt number(18,2) -- 
    ,org_amt number(18,2) -- 
    ,sale_oamt number(18,2) -- 
    ,allot_oamt number(18,2) -- 
    ,adjust_amt number(18,2) -- 
    ,sadjust_pamt number(18,2) -- 
    ,sadjust_oamt number(18,2) -- 
    ,aadjust_amt number(18,2) -- 
    ,limitbook_amt number(18,2) -- 
    ,totbook_amt number(18,2) -- 
    ,sale_bamt number(18,2) -- 
    ,hold_amt number(18,2) -- 
    ,allot_hamt number(18,2) -- 
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(end_dt)(
     partition p_19000101 values (to_date('19000101','yyyymmdd')),
     partition p_20991231 values (to_date('20991231','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.ifms_tbissamt to ${iml_schema};
grant select on ${iol_schema}.ifms_tbissamt to ${icl_schema};
grant select on ${iol_schema}.ifms_tbissamt to ${idl_schema};
grant select on ${iol_schema}.ifms_tbissamt to ${iel_schema};

-- comment
comment on table ${iol_schema}.ifms_tbissamt is '额度控制表';
comment on column ${iol_schema}.ifms_tbissamt.prd_code is '';
comment on column ${iol_schema}.ifms_tbissamt.branch_no is '';
comment on column ${iol_schema}.ifms_tbissamt.internal_branch is '';
comment on column ${iol_schema}.ifms_tbissamt.totsale_amt is '';
comment on column ${iol_schema}.ifms_tbissamt.person_amt is '';
comment on column ${iol_schema}.ifms_tbissamt.sale_pamt is '';
comment on column ${iol_schema}.ifms_tbissamt.allot_pamt is '';
comment on column ${iol_schema}.ifms_tbissamt.org_amt is '';
comment on column ${iol_schema}.ifms_tbissamt.sale_oamt is '';
comment on column ${iol_schema}.ifms_tbissamt.allot_oamt is '';
comment on column ${iol_schema}.ifms_tbissamt.adjust_amt is '';
comment on column ${iol_schema}.ifms_tbissamt.sadjust_pamt is '';
comment on column ${iol_schema}.ifms_tbissamt.sadjust_oamt is '';
comment on column ${iol_schema}.ifms_tbissamt.aadjust_amt is '';
comment on column ${iol_schema}.ifms_tbissamt.limitbook_amt is '';
comment on column ${iol_schema}.ifms_tbissamt.totbook_amt is '';
comment on column ${iol_schema}.ifms_tbissamt.sale_bamt is '';
comment on column ${iol_schema}.ifms_tbissamt.hold_amt is '';
comment on column ${iol_schema}.ifms_tbissamt.allot_hamt is '';
comment on column ${iol_schema}.ifms_tbissamt.start_dt is '开始时间';
comment on column ${iol_schema}.ifms_tbissamt.end_dt is '结束时间';
comment on column ${iol_schema}.ifms_tbissamt.id_mark is '增删标志';
comment on column ${iol_schema}.ifms_tbissamt.etl_timestamp is 'ETL处理时间戳';
