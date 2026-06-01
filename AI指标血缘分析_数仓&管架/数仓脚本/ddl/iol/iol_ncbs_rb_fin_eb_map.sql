/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_fin_eb_map
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_fin_eb_map
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_fin_eb_map purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_fin_eb_map(
    prod_type varchar2(12) -- 产品编号
    ,remark varchar2(600) -- 备注
    ,tran_type varchar2(10) -- 交易类型
    ,bill_code varchar2(3) -- 汇票类型
    ,bill_medium_type varchar2(3) -- 票据介质类型
    ,branch_flag varchar2(1) -- 机构取值标志
    ,busi_type varchar2(20) -- 业务种类
    ,company varchar2(20) -- 法人
    ,eb_acct_class varchar2(1) -- 电子汇票账户分类
    ,eb_amt_flag varchar2(1) -- 电子汇票金额类型
    ,eb_busi_type varchar2(20) -- 业务类型
    ,entity_flag varchar2(1) -- 实物标识
    ,event_type varchar2(20) -- 事件类型
    ,memo1 varchar2(50) -- 备用字段1
    ,memo2 varchar2(50) -- 备用字段2
    ,memo3 varchar2(50) -- 备用字段3
    ,online_flag varchar2(1) -- 是否联机
    ,online_offline_flag varchar2(1) -- 线上线下清算标识
    ,operate_nature_desc varchar2(50) -- 操作属性描述
    ,prod_desc varchar2(200) -- 产品名称
    ,seq_no varchar2(50) -- 序号
    ,source_type varchar2(6) -- 渠道编号
    ,eb_operate_type varchar2(10) -- 电子汇票操作类型
    ,eb_operate_type_desc varchar2(200) -- 电子汇票操作类型描述
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
grant select on ${iol_schema}.ncbs_rb_fin_eb_map to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_fin_eb_map to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_fin_eb_map to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_fin_eb_map to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_fin_eb_map is '电子汇票记账交易类型对照表';
comment on column ${iol_schema}.ncbs_rb_fin_eb_map.prod_type is '产品编号';
comment on column ${iol_schema}.ncbs_rb_fin_eb_map.remark is '备注';
comment on column ${iol_schema}.ncbs_rb_fin_eb_map.tran_type is '交易类型';
comment on column ${iol_schema}.ncbs_rb_fin_eb_map.bill_code is '汇票类型';
comment on column ${iol_schema}.ncbs_rb_fin_eb_map.bill_medium_type is '票据介质类型';
comment on column ${iol_schema}.ncbs_rb_fin_eb_map.branch_flag is '机构取值标志';
comment on column ${iol_schema}.ncbs_rb_fin_eb_map.busi_type is '业务种类';
comment on column ${iol_schema}.ncbs_rb_fin_eb_map.company is '法人';
comment on column ${iol_schema}.ncbs_rb_fin_eb_map.eb_acct_class is '电子汇票账户分类';
comment on column ${iol_schema}.ncbs_rb_fin_eb_map.eb_amt_flag is '电子汇票金额类型';
comment on column ${iol_schema}.ncbs_rb_fin_eb_map.eb_busi_type is '业务类型';
comment on column ${iol_schema}.ncbs_rb_fin_eb_map.entity_flag is '实物标识';
comment on column ${iol_schema}.ncbs_rb_fin_eb_map.event_type is '事件类型';
comment on column ${iol_schema}.ncbs_rb_fin_eb_map.memo1 is '备用字段1';
comment on column ${iol_schema}.ncbs_rb_fin_eb_map.memo2 is '备用字段2';
comment on column ${iol_schema}.ncbs_rb_fin_eb_map.memo3 is '备用字段3';
comment on column ${iol_schema}.ncbs_rb_fin_eb_map.online_flag is '是否联机';
comment on column ${iol_schema}.ncbs_rb_fin_eb_map.online_offline_flag is '线上线下清算标识';
comment on column ${iol_schema}.ncbs_rb_fin_eb_map.operate_nature_desc is '操作属性描述';
comment on column ${iol_schema}.ncbs_rb_fin_eb_map.prod_desc is '产品名称';
comment on column ${iol_schema}.ncbs_rb_fin_eb_map.seq_no is '序号';
comment on column ${iol_schema}.ncbs_rb_fin_eb_map.source_type is '渠道编号';
comment on column ${iol_schema}.ncbs_rb_fin_eb_map.eb_operate_type is '电子汇票操作类型';
comment on column ${iol_schema}.ncbs_rb_fin_eb_map.eb_operate_type_desc is '电子汇票操作类型描述';
comment on column ${iol_schema}.ncbs_rb_fin_eb_map.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_fin_eb_map.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_rb_fin_eb_map.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_rb_fin_eb_map.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_rb_fin_eb_map.etl_timestamp is 'ETL处理时间戳';
