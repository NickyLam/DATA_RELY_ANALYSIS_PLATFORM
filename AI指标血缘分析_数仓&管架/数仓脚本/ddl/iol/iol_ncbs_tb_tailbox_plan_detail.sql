/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_tb_tailbox_plan_detail
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_tb_tailbox_plan_detail
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_tb_tailbox_plan_detail purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_tb_tailbox_plan_detail(
    user_id varchar2(8) -- 交易柜员编号
    ,allot_id varchar2(50) -- 尾箱分配计划编号
    ,company varchar2(20) -- 法人
    ,tailbox_id varchar2(30) -- 尾箱代号
    ,use_status varchar2(1) -- 使用状态
    ,tran_timestamp varchar2(26) -- 交易时间戳
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
grant select on ${iol_schema}.ncbs_tb_tailbox_plan_detail to ${iml_schema};
grant select on ${iol_schema}.ncbs_tb_tailbox_plan_detail to ${icl_schema};
grant select on ${iol_schema}.ncbs_tb_tailbox_plan_detail to ${idl_schema};
grant select on ${iol_schema}.ncbs_tb_tailbox_plan_detail to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_tb_tailbox_plan_detail is '尾箱日分配计划明细表';
comment on column ${iol_schema}.ncbs_tb_tailbox_plan_detail.user_id is '交易柜员编号';
comment on column ${iol_schema}.ncbs_tb_tailbox_plan_detail.allot_id is '尾箱分配计划编号';
comment on column ${iol_schema}.ncbs_tb_tailbox_plan_detail.company is '法人';
comment on column ${iol_schema}.ncbs_tb_tailbox_plan_detail.tailbox_id is '尾箱代号';
comment on column ${iol_schema}.ncbs_tb_tailbox_plan_detail.use_status is '使用状态';
comment on column ${iol_schema}.ncbs_tb_tailbox_plan_detail.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_tb_tailbox_plan_detail.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_tb_tailbox_plan_detail.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_tb_tailbox_plan_detail.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_tb_tailbox_plan_detail.etl_timestamp is 'ETL处理时间戳';
