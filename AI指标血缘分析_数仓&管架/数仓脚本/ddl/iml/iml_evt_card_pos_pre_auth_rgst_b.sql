/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_card_pos_pre_auth_rgst_b
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_card_pos_pre_auth_rgst_b
whenever sqlerror continue none;
drop table ${iml_schema}.evt_card_pos_pre_auth_rgst_b purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_card_pos_pre_auth_rgst_b(
    evt_id varchar2(250) -- 事件编号
    ,lp_id varchar2(100) -- 法人编号
    ,tran_flow_num varchar2(100) -- 交易流水号
    ,tran_dt date -- 交易日期
    ,pre_auth_id varchar2(100) -- 预授权编号
    ,tran_termn_id varchar2(100) -- 交易终端编号
    ,chn_id varchar2(100) -- 渠道编号
    ,card_no varchar2(60) -- 卡号
    ,unionpay_dt date -- 银联日期
    ,send_org_id varchar2(100) -- 发送机构编号
    ,proc_org_id varchar2(100) -- 受理机构编号
    ,effect_dt date -- 生效日期
    ,invalid_dt date -- 失效日期
    ,cust_id varchar2(100) -- 客户编号
    ,mercht_id varchar2(100) -- 商户编号
    ,curr_cd varchar2(30) -- 币种代码
    ,tran_amt number(30,2) -- 交易金额
    ,cmplt_amt number(30,2) -- 完成金额
    ,lmt_id varchar2(100) -- 限制编号
    ,chn_bus_proc_status varchar2(30) -- 渠道业务处理状态
    ,remark varchar2(500) -- 备注
    ,tran_tm timestamp -- 交易时间
    ,sys_sub_flow_num varchar2(250) -- 系统子流水号
    ,ova_flow_num varchar2(60) -- 全局流水号
    ,tran_ref_no varchar2(60) -- 交易参考号
    ,etl_dt date -- ETL处理日期
    ,src_table_name varchar2(100) -- 源表名称
    ,job_cd varchar2(10) -- 任务编码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list (job_cd)
subpartition by list (etl_dt)
(
   partition p_default values ('default')
   (
        subpartition p_default_19000101 values (to_date('19000101','yyyymmdd'))
   )
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iml_schema}.evt_card_pos_pre_auth_rgst_b to ${icl_schema};
grant select on ${iml_schema}.evt_card_pos_pre_auth_rgst_b to ${idl_schema};
grant select on ${iml_schema}.evt_card_pos_pre_auth_rgst_b to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_card_pos_pre_auth_rgst_b is '卡片POS预授权登记簿';
comment on column ${iml_schema}.evt_card_pos_pre_auth_rgst_b.evt_id is '事件编号';
comment on column ${iml_schema}.evt_card_pos_pre_auth_rgst_b.lp_id is '法人编号';
comment on column ${iml_schema}.evt_card_pos_pre_auth_rgst_b.tran_flow_num is '交易流水号';
comment on column ${iml_schema}.evt_card_pos_pre_auth_rgst_b.tran_dt is '交易日期';
comment on column ${iml_schema}.evt_card_pos_pre_auth_rgst_b.pre_auth_id is '预授权编号';
comment on column ${iml_schema}.evt_card_pos_pre_auth_rgst_b.tran_termn_id is '交易终端编号';
comment on column ${iml_schema}.evt_card_pos_pre_auth_rgst_b.chn_id is '渠道编号';
comment on column ${iml_schema}.evt_card_pos_pre_auth_rgst_b.card_no is '卡号';
comment on column ${iml_schema}.evt_card_pos_pre_auth_rgst_b.unionpay_dt is '银联日期';
comment on column ${iml_schema}.evt_card_pos_pre_auth_rgst_b.send_org_id is '发送机构编号';
comment on column ${iml_schema}.evt_card_pos_pre_auth_rgst_b.proc_org_id is '受理机构编号';
comment on column ${iml_schema}.evt_card_pos_pre_auth_rgst_b.effect_dt is '生效日期';
comment on column ${iml_schema}.evt_card_pos_pre_auth_rgst_b.invalid_dt is '失效日期';
comment on column ${iml_schema}.evt_card_pos_pre_auth_rgst_b.cust_id is '客户编号';
comment on column ${iml_schema}.evt_card_pos_pre_auth_rgst_b.mercht_id is '商户编号';
comment on column ${iml_schema}.evt_card_pos_pre_auth_rgst_b.curr_cd is '币种代码';
comment on column ${iml_schema}.evt_card_pos_pre_auth_rgst_b.tran_amt is '交易金额';
comment on column ${iml_schema}.evt_card_pos_pre_auth_rgst_b.cmplt_amt is '完成金额';
comment on column ${iml_schema}.evt_card_pos_pre_auth_rgst_b.lmt_id is '限制编号';
comment on column ${iml_schema}.evt_card_pos_pre_auth_rgst_b.chn_bus_proc_status is '渠道业务处理状态';
comment on column ${iml_schema}.evt_card_pos_pre_auth_rgst_b.remark is '备注';
comment on column ${iml_schema}.evt_card_pos_pre_auth_rgst_b.tran_tm is '交易时间';
comment on column ${iml_schema}.evt_card_pos_pre_auth_rgst_b.sys_sub_flow_num is '系统子流水号';
comment on column ${iml_schema}.evt_card_pos_pre_auth_rgst_b.ova_flow_num is '全局流水号';
comment on column ${iml_schema}.evt_card_pos_pre_auth_rgst_b.tran_ref_no is '交易参考号';
comment on column ${iml_schema}.evt_card_pos_pre_auth_rgst_b.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.evt_card_pos_pre_auth_rgst_b.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_card_pos_pre_auth_rgst_b.job_cd is '任务编码';
comment on column ${iml_schema}.evt_card_pos_pre_auth_rgst_b.etl_timestamp is 'ETL处理时间戳';
