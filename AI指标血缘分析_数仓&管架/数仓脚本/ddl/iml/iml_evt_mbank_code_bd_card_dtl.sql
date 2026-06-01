/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_mbank_code_bd_card_dtl
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_mbank_code_bd_card_dtl
whenever sqlerror continue none;
drop table ${iml_schema}.evt_mbank_code_bd_card_dtl purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_mbank_code_bd_card_dtl(
    evt_id varchar2(250) -- 事件编号
    ,lp_id varchar2(60) -- 法人编号
    ,bind_flow_num varchar2(100) -- 绑定流水号
    ,tran_chn_cd varchar2(30) -- 交易渠道代码
    ,sign_type_cd varchar2(30) -- 签约类型代码
    ,cust_id varchar2(100) -- 交易客户编号
    ,cust_name varchar2(300) -- 客户名称
    ,vtual_card_no varchar2(100) -- 虚拟卡号
    ,enty_c_acct_id varchar2(100) -- 实体卡账户编号
    ,enty_c_acct_open_no varchar2(100) -- 实体卡账户开户行行号
    ,enty_c_acct_open_name varchar2(750) -- 实体卡账户开户行行名
    ,enty_c_acct_type_cd varchar2(30) -- 实体卡账户类型代码
    ,bd_card_tm timestamp -- 绑卡时间
    ,bd_card_status_cd varchar2(30) -- 绑卡状态代码
    ,obank_flg varchar2(10) -- 他行标志
    ,tran_teller_id varchar2(100) -- 交易柜员编号
    ,tran_org_id varchar2(100) -- 交易机构编号
    ,card_iss_org_id varchar2(100) -- 发卡机构编号
    ,deflt_pay_card_flg varchar2(10) -- 默认支付卡标志
    ,data_kind_cd varchar2(30) -- 数据种类代码
    ,update_tm timestamp -- 更新时间
    ,latest_update_flow_num varchar2(100) -- 最新更新流水号
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
grant select on ${iml_schema}.evt_mbank_code_bd_card_dtl to ${icl_schema};
grant select on ${iml_schema}.evt_mbank_code_bd_card_dtl to ${idl_schema};
grant select on ${iml_schema}.evt_mbank_code_bd_card_dtl to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_mbank_code_bd_card_dtl is '手机银行银联二维码绑卡明细';
comment on column ${iml_schema}.evt_mbank_code_bd_card_dtl.evt_id is '事件编号';
comment on column ${iml_schema}.evt_mbank_code_bd_card_dtl.lp_id is '法人编号';
comment on column ${iml_schema}.evt_mbank_code_bd_card_dtl.bind_flow_num is '绑定流水号';
comment on column ${iml_schema}.evt_mbank_code_bd_card_dtl.tran_chn_cd is '交易渠道代码';
comment on column ${iml_schema}.evt_mbank_code_bd_card_dtl.sign_type_cd is '签约类型代码';
comment on column ${iml_schema}.evt_mbank_code_bd_card_dtl.cust_id is '交易客户编号';
comment on column ${iml_schema}.evt_mbank_code_bd_card_dtl.cust_name is '客户名称';
comment on column ${iml_schema}.evt_mbank_code_bd_card_dtl.vtual_card_no is '虚拟卡号';
comment on column ${iml_schema}.evt_mbank_code_bd_card_dtl.enty_c_acct_id is '实体卡账户编号';
comment on column ${iml_schema}.evt_mbank_code_bd_card_dtl.enty_c_acct_open_no is '实体卡账户开户行行号';
comment on column ${iml_schema}.evt_mbank_code_bd_card_dtl.enty_c_acct_open_name is '实体卡账户开户行行名';
comment on column ${iml_schema}.evt_mbank_code_bd_card_dtl.enty_c_acct_type_cd is '实体卡账户类型代码';
comment on column ${iml_schema}.evt_mbank_code_bd_card_dtl.bd_card_tm is '绑卡时间';
comment on column ${iml_schema}.evt_mbank_code_bd_card_dtl.bd_card_status_cd is '绑卡状态代码';
comment on column ${iml_schema}.evt_mbank_code_bd_card_dtl.obank_flg is '他行标志';
comment on column ${iml_schema}.evt_mbank_code_bd_card_dtl.tran_teller_id is '交易柜员编号';
comment on column ${iml_schema}.evt_mbank_code_bd_card_dtl.tran_org_id is '交易机构编号';
comment on column ${iml_schema}.evt_mbank_code_bd_card_dtl.card_iss_org_id is '发卡机构编号';
comment on column ${iml_schema}.evt_mbank_code_bd_card_dtl.deflt_pay_card_flg is '默认支付卡标志';
comment on column ${iml_schema}.evt_mbank_code_bd_card_dtl.data_kind_cd is '数据种类代码';
comment on column ${iml_schema}.evt_mbank_code_bd_card_dtl.update_tm is '更新时间';
comment on column ${iml_schema}.evt_mbank_code_bd_card_dtl.latest_update_flow_num is '最新更新流水号';
comment on column ${iml_schema}.evt_mbank_code_bd_card_dtl.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.evt_mbank_code_bd_card_dtl.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_mbank_code_bd_card_dtl.job_cd is '任务编码';
comment on column ${iml_schema}.evt_mbank_code_bd_card_dtl.etl_timestamp is 'ETL处理时间戳';
