/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol bdms_bms_product_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.bdms_bms_product_info
whenever sqlerror continue none;
drop table ${iol_schema}.bdms_bms_product_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdms_bms_product_info(
    id varchar2(60) -- 
    ,product_name varchar2(150) -- 产品名称
    ,product_no varchar2(12) -- 产品号
    ,busi_type varchar2(5) -- 业务种类
    ,busi_attr_name varchar2(75) -- 业务属性名称
    ,busi_attr_no varchar2(5) -- 业务属性号
    ,draft_attr varchar2(2) -- 票据属性
    ,draft_type varchar2(2) -- 票据类型
    ,dualcontrol_lockstatus varchar2(3) -- 双岗复核锁标记
    ,last_operator_no varchar2(45) -- 最后操作员编号
    ,last_txn_date timestamp -- 最后操作日期
    ,status varchar2(2) -- 状态
    ,trans_no varchar2(30) -- 
    ,top_branch_no varchar2(30) -- 所属总行机构
    ,jiti_type varchar2(2) -- 计提类型 1;贴现 2:转贴现 3:买入质押式回购 4:买入买断式回购 5:卖出质押式回购 6:卖出买断式回购 7.再贴现回购
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
grant select on ${iol_schema}.bdms_bms_product_info to ${iml_schema};
grant select on ${iol_schema}.bdms_bms_product_info to ${icl_schema};
grant select on ${iol_schema}.bdms_bms_product_info to ${idl_schema};
grant select on ${iol_schema}.bdms_bms_product_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.bdms_bms_product_info is '产品信息表';
comment on column ${iol_schema}.bdms_bms_product_info.id is '';
comment on column ${iol_schema}.bdms_bms_product_info.product_name is '产品名称';
comment on column ${iol_schema}.bdms_bms_product_info.product_no is '产品号';
comment on column ${iol_schema}.bdms_bms_product_info.busi_type is '业务种类';
comment on column ${iol_schema}.bdms_bms_product_info.busi_attr_name is '业务属性名称';
comment on column ${iol_schema}.bdms_bms_product_info.busi_attr_no is '业务属性号';
comment on column ${iol_schema}.bdms_bms_product_info.draft_attr is '票据属性';
comment on column ${iol_schema}.bdms_bms_product_info.draft_type is '票据类型';
comment on column ${iol_schema}.bdms_bms_product_info.dualcontrol_lockstatus is '双岗复核锁标记';
comment on column ${iol_schema}.bdms_bms_product_info.last_operator_no is '最后操作员编号';
comment on column ${iol_schema}.bdms_bms_product_info.last_txn_date is '最后操作日期';
comment on column ${iol_schema}.bdms_bms_product_info.status is '状态';
comment on column ${iol_schema}.bdms_bms_product_info.trans_no is '';
comment on column ${iol_schema}.bdms_bms_product_info.top_branch_no is '所属总行机构';
comment on column ${iol_schema}.bdms_bms_product_info.jiti_type is '计提类型 1;贴现 2:转贴现 3:买入质押式回购 4:买入买断式回购 5:卖出质押式回购 6:卖出买断式回购 7.再贴现回购';
comment on column ${iol_schema}.bdms_bms_product_info.start_dt is '开始时间';
comment on column ${iol_schema}.bdms_bms_product_info.end_dt is '结束时间';
comment on column ${iol_schema}.bdms_bms_product_info.id_mark is '增删标志';
comment on column ${iol_schema}.bdms_bms_product_info.etl_timestamp is 'ETL处理时间戳';
