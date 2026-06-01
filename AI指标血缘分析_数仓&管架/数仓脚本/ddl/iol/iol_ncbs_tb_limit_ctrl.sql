/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_tb_limit_ctrl
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_tb_limit_ctrl
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_tb_limit_ctrl purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_tb_limit_ctrl(
    remark varchar2(600) -- 备注
    ,user_id varchar2(8) -- 交易柜员编号
    ,company varchar2(20) -- 法人
    ,ctrl_desc varchar2(50) -- 控制描述
    ,ctrl_id varchar2(50) -- 控制编号
    ,ctrl_type varchar2(1) -- 尾箱限额类型
    ,eod_deal_flow varchar2(1) -- 日终处理方式
    ,limit_status varchar2(1) -- 限额状态
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,online_check varchar2(1) -- 是否日间限额检查标志
    ,online_deal_flow varchar2(1) -- 日间处理方式
    ,eod_check varchar2(1) -- 是否日终限额检查标志
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
grant select on ${iol_schema}.ncbs_tb_limit_ctrl to ${iml_schema};
grant select on ${iol_schema}.ncbs_tb_limit_ctrl to ${icl_schema};
grant select on ${iol_schema}.ncbs_tb_limit_ctrl to ${idl_schema};
grant select on ${iol_schema}.ncbs_tb_limit_ctrl to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_tb_limit_ctrl is '尾箱限额控制表';
comment on column ${iol_schema}.ncbs_tb_limit_ctrl.remark is '备注';
comment on column ${iol_schema}.ncbs_tb_limit_ctrl.user_id is '交易柜员编号';
comment on column ${iol_schema}.ncbs_tb_limit_ctrl.company is '法人';
comment on column ${iol_schema}.ncbs_tb_limit_ctrl.ctrl_desc is '控制描述';
comment on column ${iol_schema}.ncbs_tb_limit_ctrl.ctrl_id is '控制编号';
comment on column ${iol_schema}.ncbs_tb_limit_ctrl.ctrl_type is '尾箱限额类型';
comment on column ${iol_schema}.ncbs_tb_limit_ctrl.eod_deal_flow is '日终处理方式';
comment on column ${iol_schema}.ncbs_tb_limit_ctrl.limit_status is '限额状态';
comment on column ${iol_schema}.ncbs_tb_limit_ctrl.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_tb_limit_ctrl.online_check is '是否日间限额检查标志';
comment on column ${iol_schema}.ncbs_tb_limit_ctrl.online_deal_flow is '日间处理方式';
comment on column ${iol_schema}.ncbs_tb_limit_ctrl.eod_check is '是否日终限额检查标志';
comment on column ${iol_schema}.ncbs_tb_limit_ctrl.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_tb_limit_ctrl.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_tb_limit_ctrl.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_tb_limit_ctrl.etl_timestamp is 'ETL处理时间戳';
