/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_bill_bus_stl_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_bill_bus_stl_info
whenever sqlerror continue none;
drop table ${iml_schema}.agt_bill_bus_stl_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_bill_bus_stl_info(
    bus_stl_id varchar2(60) -- 业务结算编号
    ,lp_id varchar2(60) -- 法人编号
    ,mem_org_cd varchar2(10) -- 会员机构代码
    ,stl_req_id varchar2(60) -- 结算请求编号
    ,stl_tm timestamp -- 结算时间
    ,bus_type_cd varchar2(10) -- 业务类型代码
    ,stl_way_cd varchar2(10) -- 结算方式代码
    ,stl_bus_type_cd varchar2(10) -- 结算业务类型代码
    ,clear_type_cd varchar2(10) -- 清算类型代码
    ,bag_dir_cd varchar2(10) -- 成交方向代码
    ,stl_amt number(30,2) -- 转贴现金额
    ,int_paybl number(30,8) -- 应付利息
    ,bill_cnt number(10) -- 票据张数
    ,ctr_nt_id varchar2(60) -- 成交单编号
    ,lg_pay_sys_msg_ind_no varchar2(60) -- 大额支付系统报文标识号
    ,bill_num varchar2(60) -- 票据号码
    ,recver_org_cd varchar2(10) -- 收款方机构代码
    ,recver_trust_acct_num varchar2(60) -- 收款方托管账号
    ,recver_trust_acct_name varchar2(750) -- 收款方托管账户名称
    ,recver_cap_acct_num varchar2(60) -- 收款方资金账号
    ,recver_cap_acct_name varchar2(750) -- 收款方资金账户名称
    ,payer_org_cd varchar2(10) -- 付款方机构代码
    ,payer_trust_acct_num varchar2(60) -- 付款方托管账号
    ,payer_trust_acct_name varchar2(750) -- 付款方托管账户名称
    ,payer_cap_acct_num varchar2(60) -- 付款方资金账号
    ,payer_cap_acct_name varchar2(750) -- 付款方资金账户名称
    ,stl_status_cd varchar2(10) -- 结算状态代码
    ,stl_rest_code varchar2(90) -- 结算结果编码
    ,stl_fail_rs varchar2(150) -- 结算失败原因
    ,bill_sub_intrv_id varchar2(60) -- 票据子区间编号
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
grant select on ${iml_schema}.agt_bill_bus_stl_info to ${icl_schema};
grant select on ${iml_schema}.agt_bill_bus_stl_info to ${idl_schema};
grant select on ${iml_schema}.agt_bill_bus_stl_info to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_bill_bus_stl_info is '票据业务结算信息';
comment on column ${iml_schema}.agt_bill_bus_stl_info.bus_stl_id is '业务结算编号';
comment on column ${iml_schema}.agt_bill_bus_stl_info.lp_id is '法人编号';
comment on column ${iml_schema}.agt_bill_bus_stl_info.mem_org_cd is '会员机构代码';
comment on column ${iml_schema}.agt_bill_bus_stl_info.stl_req_id is '结算请求编号';
comment on column ${iml_schema}.agt_bill_bus_stl_info.stl_tm is '结算时间';
comment on column ${iml_schema}.agt_bill_bus_stl_info.bus_type_cd is '业务类型代码';
comment on column ${iml_schema}.agt_bill_bus_stl_info.stl_way_cd is '结算方式代码';
comment on column ${iml_schema}.agt_bill_bus_stl_info.stl_bus_type_cd is '结算业务类型代码';
comment on column ${iml_schema}.agt_bill_bus_stl_info.clear_type_cd is '清算类型代码';
comment on column ${iml_schema}.agt_bill_bus_stl_info.bag_dir_cd is '成交方向代码';
comment on column ${iml_schema}.agt_bill_bus_stl_info.stl_amt is '转贴现金额';
comment on column ${iml_schema}.agt_bill_bus_stl_info.int_paybl is '应付利息';
comment on column ${iml_schema}.agt_bill_bus_stl_info.bill_cnt is '票据张数';
comment on column ${iml_schema}.agt_bill_bus_stl_info.ctr_nt_id is '成交单编号';
comment on column ${iml_schema}.agt_bill_bus_stl_info.lg_pay_sys_msg_ind_no is '大额支付系统报文标识号';
comment on column ${iml_schema}.agt_bill_bus_stl_info.bill_num is '票据号码';
comment on column ${iml_schema}.agt_bill_bus_stl_info.recver_org_cd is '收款方机构代码';
comment on column ${iml_schema}.agt_bill_bus_stl_info.recver_trust_acct_num is '收款方托管账号';
comment on column ${iml_schema}.agt_bill_bus_stl_info.recver_trust_acct_name is '收款方托管账户名称';
comment on column ${iml_schema}.agt_bill_bus_stl_info.recver_cap_acct_num is '收款方资金账号';
comment on column ${iml_schema}.agt_bill_bus_stl_info.recver_cap_acct_name is '收款方资金账户名称';
comment on column ${iml_schema}.agt_bill_bus_stl_info.payer_org_cd is '付款方机构代码';
comment on column ${iml_schema}.agt_bill_bus_stl_info.payer_trust_acct_num is '付款方托管账号';
comment on column ${iml_schema}.agt_bill_bus_stl_info.payer_trust_acct_name is '付款方托管账户名称';
comment on column ${iml_schema}.agt_bill_bus_stl_info.payer_cap_acct_num is '付款方资金账号';
comment on column ${iml_schema}.agt_bill_bus_stl_info.payer_cap_acct_name is '付款方资金账户名称';
comment on column ${iml_schema}.agt_bill_bus_stl_info.stl_status_cd is '结算状态代码';
comment on column ${iml_schema}.agt_bill_bus_stl_info.stl_rest_code is '结算结果编码';
comment on column ${iml_schema}.agt_bill_bus_stl_info.stl_fail_rs is '结算失败原因';
comment on column ${iml_schema}.agt_bill_bus_stl_info.bill_sub_intrv_id is '票据子区间编号';
comment on column ${iml_schema}.agt_bill_bus_stl_info.start_dt is '开始时间';
comment on column ${iml_schema}.agt_bill_bus_stl_info.end_dt is '结束时间';
comment on column ${iml_schema}.agt_bill_bus_stl_info.id_mark is '增删标志';
comment on column ${iml_schema}.agt_bill_bus_stl_info.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_bill_bus_stl_info.job_cd is '任务编码';
comment on column ${iml_schema}.agt_bill_bus_stl_info.etl_timestamp is 'ETL处理时间戳';
