/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_rgst_cter_bill_ccution
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_rgst_cter_bill_ccution
whenever sqlerror continue none;
drop table ${iml_schema}.evt_rgst_cter_bill_ccution purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_rgst_cter_bill_ccution(
    evt_id varchar2(60) -- 事件编号
    ,lp_id varchar2(60) -- 法人编号
    ,rgst_id varchar2(60) -- 登记编号
    ,agt_id varchar2(60) -- 协议编号
    ,agt_dtl_id varchar2(60) -- 协议明细编号
    ,bill_id varchar2(60) -- 票据编号
    ,bus_type_cd varchar2(30) -- 业务类型代码
    ,bus_attr_cd varchar2(10) -- 业务属性代码
    ,bill_num varchar2(60) -- 票据号码
    ,tran_dir_cd varchar2(10) -- 交易方向代码
    ,tran_dt date -- 交易日期
    ,reqer_type_cd varchar2(10) -- 请求方类型代码
    ,reqer_name varchar2(150) -- 请求方名称
    ,reqer_soci_crdt_cd varchar2(30) -- 请求方社会信用代码
    ,reqer_acct_num varchar2(60) -- 请求方账号
    ,reqer_mem_id varchar2(60) -- 请求方会员编号
    ,reqer_org_id varchar2(60) -- 请求方机构编号
    ,reqer_pay_sys_bank_no varchar2(60) -- 请求方支付系统行行号
    ,recver_type_cd varchar2(10) -- 接收方类型代码
    ,recver_name varchar2(150) -- 接收方名称
    ,recver_soci_crdt_cd varchar2(30) -- 接收方社会信用代码
    ,recver_acct_num varchar2(60) -- 接收方账号
    ,recver_mem_code varchar2(90) -- 接收方会员编码
    ,recver_org_id varchar2(60) -- 接收方机构编号
    ,recver_pay_sys_bank_no varchar2(60) -- 接收方支付系统行行号
    ,actl_amt number(30,2) -- 贴现金额
    ,actl_int number(30,2) -- 实付利息
    ,int_rat number(18,8) -- 利率
    ,stop_pay_type_cd varchar2(10) -- 止付类型代码
    ,remit_stop_pay_type_cd varchar2(10) -- 解除止付类型代码
    ,surp_tenor number(10) -- 剩余期限
    ,stl_amt number(30,2) -- 转贴现金额
    ,sys_in_flg varchar2(10) -- 系统外标志
    ,tran_status_cd varchar2(10) -- 交易状态代码
    ,payoff_type_cd varchar2(10) -- 结清类型代码
    ,invtry_org_id varchar2(60) -- 库存机构编号
    ,hq_org_id varchar2(60) -- 总行机构编号
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
grant select on ${iml_schema}.evt_rgst_cter_bill_ccution to ${icl_schema};
grant select on ${iml_schema}.evt_rgst_cter_bill_ccution to ${idl_schema};
grant select on ${iml_schema}.evt_rgst_cter_bill_ccution to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_rgst_cter_bill_ccution is '登记中心票据流转事件';
comment on column ${iml_schema}.evt_rgst_cter_bill_ccution.evt_id is '事件编号';
comment on column ${iml_schema}.evt_rgst_cter_bill_ccution.lp_id is '法人编号';
comment on column ${iml_schema}.evt_rgst_cter_bill_ccution.rgst_id is '登记编号';
comment on column ${iml_schema}.evt_rgst_cter_bill_ccution.agt_id is '协议编号';
comment on column ${iml_schema}.evt_rgst_cter_bill_ccution.agt_dtl_id is '协议明细编号';
comment on column ${iml_schema}.evt_rgst_cter_bill_ccution.bill_id is '票据编号';
comment on column ${iml_schema}.evt_rgst_cter_bill_ccution.bus_type_cd is '业务类型代码';
comment on column ${iml_schema}.evt_rgst_cter_bill_ccution.bus_attr_cd is '业务属性代码';
comment on column ${iml_schema}.evt_rgst_cter_bill_ccution.bill_num is '票据号码';
comment on column ${iml_schema}.evt_rgst_cter_bill_ccution.tran_dir_cd is '交易方向代码';
comment on column ${iml_schema}.evt_rgst_cter_bill_ccution.tran_dt is '交易日期';
comment on column ${iml_schema}.evt_rgst_cter_bill_ccution.reqer_type_cd is '请求方类型代码';
comment on column ${iml_schema}.evt_rgst_cter_bill_ccution.reqer_name is '请求方名称';
comment on column ${iml_schema}.evt_rgst_cter_bill_ccution.reqer_soci_crdt_cd is '请求方社会信用代码';
comment on column ${iml_schema}.evt_rgst_cter_bill_ccution.reqer_acct_num is '请求方账号';
comment on column ${iml_schema}.evt_rgst_cter_bill_ccution.reqer_mem_id is '请求方会员编号';
comment on column ${iml_schema}.evt_rgst_cter_bill_ccution.reqer_org_id is '请求方机构编号';
comment on column ${iml_schema}.evt_rgst_cter_bill_ccution.reqer_pay_sys_bank_no is '请求方支付系统行行号';
comment on column ${iml_schema}.evt_rgst_cter_bill_ccution.recver_type_cd is '接收方类型代码';
comment on column ${iml_schema}.evt_rgst_cter_bill_ccution.recver_name is '接收方名称';
comment on column ${iml_schema}.evt_rgst_cter_bill_ccution.recver_soci_crdt_cd is '接收方社会信用代码';
comment on column ${iml_schema}.evt_rgst_cter_bill_ccution.recver_acct_num is '接收方账号';
comment on column ${iml_schema}.evt_rgst_cter_bill_ccution.recver_mem_code is '接收方会员编码';
comment on column ${iml_schema}.evt_rgst_cter_bill_ccution.recver_org_id is '接收方机构编号';
comment on column ${iml_schema}.evt_rgst_cter_bill_ccution.recver_pay_sys_bank_no is '接收方支付系统行行号';
comment on column ${iml_schema}.evt_rgst_cter_bill_ccution.actl_amt is '贴现金额';
comment on column ${iml_schema}.evt_rgst_cter_bill_ccution.actl_int is '实付利息';
comment on column ${iml_schema}.evt_rgst_cter_bill_ccution.int_rat is '利率';
comment on column ${iml_schema}.evt_rgst_cter_bill_ccution.stop_pay_type_cd is '止付类型代码';
comment on column ${iml_schema}.evt_rgst_cter_bill_ccution.remit_stop_pay_type_cd is '解除止付类型代码';
comment on column ${iml_schema}.evt_rgst_cter_bill_ccution.surp_tenor is '剩余期限';
comment on column ${iml_schema}.evt_rgst_cter_bill_ccution.stl_amt is '转贴现金额';
comment on column ${iml_schema}.evt_rgst_cter_bill_ccution.sys_in_flg is '系统外标志';
comment on column ${iml_schema}.evt_rgst_cter_bill_ccution.tran_status_cd is '交易状态代码';
comment on column ${iml_schema}.evt_rgst_cter_bill_ccution.payoff_type_cd is '结清类型代码';
comment on column ${iml_schema}.evt_rgst_cter_bill_ccution.invtry_org_id is '库存机构编号';
comment on column ${iml_schema}.evt_rgst_cter_bill_ccution.hq_org_id is '总行机构编号';
comment on column ${iml_schema}.evt_rgst_cter_bill_ccution.start_dt is '开始时间';
comment on column ${iml_schema}.evt_rgst_cter_bill_ccution.end_dt is '结束时间';
comment on column ${iml_schema}.evt_rgst_cter_bill_ccution.id_mark is '增删标志';
comment on column ${iml_schema}.evt_rgst_cter_bill_ccution.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_rgst_cter_bill_ccution.job_cd is '任务编码';
comment on column ${iml_schema}.evt_rgst_cter_bill_ccution.etl_timestamp is 'ETL处理时间戳';
