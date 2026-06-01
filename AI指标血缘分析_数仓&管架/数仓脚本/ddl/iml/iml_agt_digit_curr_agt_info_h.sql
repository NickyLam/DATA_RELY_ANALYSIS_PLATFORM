/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_digit_curr_agt_info_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_digit_curr_agt_info_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_digit_curr_agt_info_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_digit_curr_agt_info_h(
    agt_id varchar2(250) -- 协议编号
    ,lp_id varchar2(100) -- 法人编号
    ,midgrod_flow_num varchar2(100) -- 中台流水号
    ,midgrod_tran_dt date -- 中台交易日期
    ,cust_type_cd varchar2(30) -- 客户类型代码
    ,cust_id varchar2(100) -- 客户编号
    ,src_agt_id varchar2(100) -- 源协议编号
    ,sign_status_cd varchar2(30) -- 签约状态代码
    ,agt_effect_dt date -- 协议生效日期
    ,agt_invalid_dt date -- 协议失效日期
    ,sign_acct_id varchar2(1000) -- 签约账户编号
    ,sign_acct_name varchar2(1000) -- 签约账户名称
    ,sign_acct_type_cd varchar2(30) -- 签约账户类型代码
    ,sign_cert_type_cd varchar2(30) -- 签约证件类型代码
    ,sign_cert_no varchar2(1000) -- 签约证件号码
    ,sign_cert_invalid_dt date -- 签约证件失效日期
    ,sign_belong_org_id varchar2(100) -- 签约所属机构编号
    ,sign_belong_org_name varchar2(500) -- 签约所属机构名称
    ,sign_dt date -- 签约日期
    ,sign_termn_cd varchar2(30) -- 签约终端代码
    ,sign_teller_id varchar2(100) -- 签约柜员编号
    ,rsrv_mobile_no varchar2(1000) -- 预留手机号码
    ,pkg_open_belong_org_id varchar2(100) -- 钱包开立所属机构编号
    ,pkg_open_belong_org_name varchar2(500) -- 钱包开立所属机构名称
    ,pkg_id varchar2(1500) -- 钱包编号
    ,pkg_type_cd varchar2(30) -- 钱包类型代码
    ,pkg_level_cd varchar2(30) -- 钱包等级代码
    ,rels_flow_num varchar2(100) -- 解约流水号
    ,rels_dt date -- 解约日期
    ,rels_teller_id varchar2(100) -- 解约柜员编号
    ,aldy_change_card_flg varchar2(10) -- 已换卡标志
    ,new_card_acct_id varchar2(250) -- 新卡账户编号
    ,change_card_tm timestamp -- 换卡时间
    ,init_init_org_id varchar2(100) -- 原发起机构编号
    ,corp_name varchar2(500) -- 单位名称
    ,corp_princ_name varchar2(1500) -- 单位负责人名称
    ,corp_princ_cert_type_cd varchar2(30) -- 单位负责人证件类型代码
    ,corp_princ_cert_no varchar2(1500) -- 单位负责人证件号码
    ,sig_acpt_bus_amt_uplmi number(18,8) -- 单笔兑出业务金额上限
    ,d_acm_acpt_bus_upcnt number(18,8) -- 日累计兑出业务笔数上限
    ,d_acm_acpt_bus_uplmi number(18,8) -- 日累计兑出业务金额上限
    ,y_acm_acpt_bus_upcnt number(18,8) -- 年累计兑出业务笔数上限
    ,y_acm_acpt_bus_uplmi number(18,8) -- 年累计兑出业务金额上限
    ,mgmt_org_id varchar2(100) -- 管理机构编号
    ,msg_id varchar2(100) -- 报文编号
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,src_table_name varchar2(100) -- 源表名称
    ,job_cd varchar2(10) -- 任务编码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list (job_cd)
subpartition by list (end_dt)
(
   partition p_default values ('default')
   (
         subpartition p_default_19000101 values (to_date('19000101','yyyymmdd'))
         ,subpartition p_default_20991231 values (to_date('20991231','yyyymmdd'))
   )
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iml_schema}.agt_digit_curr_agt_info_h to ${icl_schema};
grant select on ${iml_schema}.agt_digit_curr_agt_info_h to ${idl_schema};
grant select on ${iml_schema}.agt_digit_curr_agt_info_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_digit_curr_agt_info_h is '数字货币挂接协议信息历史';
comment on column ${iml_schema}.agt_digit_curr_agt_info_h.agt_id is '协议编号';
comment on column ${iml_schema}.agt_digit_curr_agt_info_h.lp_id is '法人编号';
comment on column ${iml_schema}.agt_digit_curr_agt_info_h.midgrod_flow_num is '中台流水号';
comment on column ${iml_schema}.agt_digit_curr_agt_info_h.midgrod_tran_dt is '中台交易日期';
comment on column ${iml_schema}.agt_digit_curr_agt_info_h.cust_type_cd is '客户类型代码';
comment on column ${iml_schema}.agt_digit_curr_agt_info_h.cust_id is '客户编号';
comment on column ${iml_schema}.agt_digit_curr_agt_info_h.src_agt_id is '源协议编号';
comment on column ${iml_schema}.agt_digit_curr_agt_info_h.sign_status_cd is '签约状态代码';
comment on column ${iml_schema}.agt_digit_curr_agt_info_h.agt_effect_dt is '协议生效日期';
comment on column ${iml_schema}.agt_digit_curr_agt_info_h.agt_invalid_dt is '协议失效日期';
comment on column ${iml_schema}.agt_digit_curr_agt_info_h.sign_acct_id is '签约账户编号';
comment on column ${iml_schema}.agt_digit_curr_agt_info_h.sign_acct_name is '签约账户名称';
comment on column ${iml_schema}.agt_digit_curr_agt_info_h.sign_acct_type_cd is '签约账户类型代码';
comment on column ${iml_schema}.agt_digit_curr_agt_info_h.sign_cert_type_cd is '签约证件类型代码';
comment on column ${iml_schema}.agt_digit_curr_agt_info_h.sign_cert_no is '签约证件号码';
comment on column ${iml_schema}.agt_digit_curr_agt_info_h.sign_cert_invalid_dt is '签约证件失效日期';
comment on column ${iml_schema}.agt_digit_curr_agt_info_h.sign_belong_org_id is '签约所属机构编号';
comment on column ${iml_schema}.agt_digit_curr_agt_info_h.sign_belong_org_name is '签约所属机构名称';
comment on column ${iml_schema}.agt_digit_curr_agt_info_h.sign_dt is '签约日期';
comment on column ${iml_schema}.agt_digit_curr_agt_info_h.sign_termn_cd is '签约终端代码';
comment on column ${iml_schema}.agt_digit_curr_agt_info_h.sign_teller_id is '签约柜员编号';
comment on column ${iml_schema}.agt_digit_curr_agt_info_h.rsrv_mobile_no is '预留手机号码';
comment on column ${iml_schema}.agt_digit_curr_agt_info_h.pkg_open_belong_org_id is '钱包开立所属机构编号';
comment on column ${iml_schema}.agt_digit_curr_agt_info_h.pkg_open_belong_org_name is '钱包开立所属机构名称';
comment on column ${iml_schema}.agt_digit_curr_agt_info_h.pkg_id is '钱包编号';
comment on column ${iml_schema}.agt_digit_curr_agt_info_h.pkg_type_cd is '钱包类型代码';
comment on column ${iml_schema}.agt_digit_curr_agt_info_h.pkg_level_cd is '钱包等级代码';
comment on column ${iml_schema}.agt_digit_curr_agt_info_h.rels_flow_num is '解约流水号';
comment on column ${iml_schema}.agt_digit_curr_agt_info_h.rels_dt is '解约日期';
comment on column ${iml_schema}.agt_digit_curr_agt_info_h.rels_teller_id is '解约柜员编号';
comment on column ${iml_schema}.agt_digit_curr_agt_info_h.aldy_change_card_flg is '已换卡标志';
comment on column ${iml_schema}.agt_digit_curr_agt_info_h.new_card_acct_id is '新卡账户编号';
comment on column ${iml_schema}.agt_digit_curr_agt_info_h.change_card_tm is '换卡时间';
comment on column ${iml_schema}.agt_digit_curr_agt_info_h.init_init_org_id is '原发起机构编号';
comment on column ${iml_schema}.agt_digit_curr_agt_info_h.corp_name is '单位名称';
comment on column ${iml_schema}.agt_digit_curr_agt_info_h.corp_princ_name is '单位负责人名称';
comment on column ${iml_schema}.agt_digit_curr_agt_info_h.corp_princ_cert_type_cd is '单位负责人证件类型代码';
comment on column ${iml_schema}.agt_digit_curr_agt_info_h.corp_princ_cert_no is '单位负责人证件号码';
comment on column ${iml_schema}.agt_digit_curr_agt_info_h.sig_acpt_bus_amt_uplmi is '单笔兑出业务金额上限';
comment on column ${iml_schema}.agt_digit_curr_agt_info_h.d_acm_acpt_bus_upcnt is '日累计兑出业务笔数上限';
comment on column ${iml_schema}.agt_digit_curr_agt_info_h.d_acm_acpt_bus_uplmi is '日累计兑出业务金额上限';
comment on column ${iml_schema}.agt_digit_curr_agt_info_h.y_acm_acpt_bus_upcnt is '年累计兑出业务笔数上限';
comment on column ${iml_schema}.agt_digit_curr_agt_info_h.y_acm_acpt_bus_uplmi is '年累计兑出业务金额上限';
comment on column ${iml_schema}.agt_digit_curr_agt_info_h.mgmt_org_id is '管理机构编号';
comment on column ${iml_schema}.agt_digit_curr_agt_info_h.msg_id is '报文编号';
comment on column ${iml_schema}.agt_digit_curr_agt_info_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_digit_curr_agt_info_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_digit_curr_agt_info_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_digit_curr_agt_info_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_digit_curr_agt_info_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_digit_curr_agt_info_h.etl_timestamp is 'ETL处理时间戳';
