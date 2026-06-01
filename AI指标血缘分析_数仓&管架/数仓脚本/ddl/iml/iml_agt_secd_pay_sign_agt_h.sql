/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_secd_pay_sign_agt_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_secd_pay_sign_agt_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_secd_pay_sign_agt_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_secd_pay_sign_agt_h(
    agt_id varchar2(250) -- 协议编号
    ,lp_id varchar2(100) -- 法人编号
    ,src_agt_id varchar2(100) -- 源协议编号
    ,agt_sign_dt date -- 协议签署日期
    ,init_dir_prtcpt_org_id varchar2(100) -- 发起直接参与机构编号
    ,init_chn_flow_num varchar2(100) -- 原渠道流水号
    ,init_agt_id varchar2(100) -- 初始协议编号
    ,agt_status_cd varchar2(30) -- 协议状态代码
    ,coll_agt_type_cd varchar2(30) -- 代收协议类型代码
    ,stock_agt_flg varchar2(10) -- 存量协议标志
    ,effect_dt date -- 生效日期
    ,invalid_dt date -- 失效日期
    ,tran_dt date -- 交易日期
    ,tran_tm timestamp -- 交易时间
    ,update_tm timestamp -- 更新时间
    ,cust_id varchar2(100) -- 客户编号
    ,cust_name varchar2(750) -- 客户名称
    ,nostro_cd varchar2(30) -- 往来账代码
    ,acpt_pay_type_cd varchar2(30) -- 收付款类型代码
    ,recver_acct_id varchar2(100) -- 收款人账户编号
    ,recver_name varchar2(750) -- 收款人名称
    ,recvbl_bank_no varchar2(60) -- 收款行号
    ,recv_bank_name varchar2(750) -- 收款行名称
    ,payer_acct_id varchar2(100) -- 付款人账户编号
    ,payer_name varchar2(750) -- 付款人名称
    ,payer_acct_type varchar2(15) -- 付款人账户类型
    ,payer_open_bank_num varchar2(60) -- 付款人开户行号
    ,pay_bank_bank_no varchar2(60) -- 付款行行号
    ,pay_bank_name varchar2(750) -- 付款行名称
    ,once_deduct_lmt number(30,2) -- 一次性扣款限额
    ,deduct_ped_int_lmt_cnt number(10) -- 扣款周期内限制笔数
    ,deduct_ped_inner_buckle_fee_lmt number(30,2) -- 扣款周期内扣费限额
    ,deduct_tm_corp varchar2(10) -- 扣款时间单位
    ,deduct_tm_length number(10) -- 扣款时间长度
    ,deduct_tm_descb varchar2(500) -- 扣款时间描述
    ,addit_info varchar2(750) -- 附加信息
    ,err_info_desc varchar2(750) -- 错误信息描述
    ,auth_mode_cd varchar2(30) -- 授权模式代码
    ,postsc varchar2(750) -- 附言
    ,whole_proc_idf varchar2(15) -- 全行处理标识
    ,open_acct_org_id varchar2(100) -- 开户机构编号
    ,tran_org_id varchar2(100) -- 交易机构编号
    ,proc_org_id varchar2(100) -- 处理机构编号
    ,tran_teller_id varchar2(100) -- 交易柜员编号
    ,auth_teller_id varchar2(100) -- 授权柜员编号
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
grant select on ${iml_schema}.agt_secd_pay_sign_agt_h to ${icl_schema};
grant select on ${iml_schema}.agt_secd_pay_sign_agt_h to ${idl_schema};
grant select on ${iml_schema}.agt_secd_pay_sign_agt_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_secd_pay_sign_agt_h is '二代支付签约协议历史';
comment on column ${iml_schema}.agt_secd_pay_sign_agt_h.agt_id is '协议编号';
comment on column ${iml_schema}.agt_secd_pay_sign_agt_h.lp_id is '法人编号';
comment on column ${iml_schema}.agt_secd_pay_sign_agt_h.src_agt_id is '源协议编号';
comment on column ${iml_schema}.agt_secd_pay_sign_agt_h.agt_sign_dt is '协议签署日期';
comment on column ${iml_schema}.agt_secd_pay_sign_agt_h.init_dir_prtcpt_org_id is '发起直接参与机构编号';
comment on column ${iml_schema}.agt_secd_pay_sign_agt_h.init_chn_flow_num is '原渠道流水号';
comment on column ${iml_schema}.agt_secd_pay_sign_agt_h.init_agt_id is '初始协议编号';
comment on column ${iml_schema}.agt_secd_pay_sign_agt_h.agt_status_cd is '协议状态代码';
comment on column ${iml_schema}.agt_secd_pay_sign_agt_h.coll_agt_type_cd is '代收协议类型代码';
comment on column ${iml_schema}.agt_secd_pay_sign_agt_h.stock_agt_flg is '存量协议标志';
comment on column ${iml_schema}.agt_secd_pay_sign_agt_h.effect_dt is '生效日期';
comment on column ${iml_schema}.agt_secd_pay_sign_agt_h.invalid_dt is '失效日期';
comment on column ${iml_schema}.agt_secd_pay_sign_agt_h.tran_dt is '交易日期';
comment on column ${iml_schema}.agt_secd_pay_sign_agt_h.tran_tm is '交易时间';
comment on column ${iml_schema}.agt_secd_pay_sign_agt_h.update_tm is '更新时间';
comment on column ${iml_schema}.agt_secd_pay_sign_agt_h.cust_id is '客户编号';
comment on column ${iml_schema}.agt_secd_pay_sign_agt_h.cust_name is '客户名称';
comment on column ${iml_schema}.agt_secd_pay_sign_agt_h.nostro_cd is '往来账代码';
comment on column ${iml_schema}.agt_secd_pay_sign_agt_h.acpt_pay_type_cd is '收付款类型代码';
comment on column ${iml_schema}.agt_secd_pay_sign_agt_h.recver_acct_id is '收款人账户编号';
comment on column ${iml_schema}.agt_secd_pay_sign_agt_h.recver_name is '收款人名称';
comment on column ${iml_schema}.agt_secd_pay_sign_agt_h.recvbl_bank_no is '收款行号';
comment on column ${iml_schema}.agt_secd_pay_sign_agt_h.recv_bank_name is '收款行名称';
comment on column ${iml_schema}.agt_secd_pay_sign_agt_h.payer_acct_id is '付款人账户编号';
comment on column ${iml_schema}.agt_secd_pay_sign_agt_h.payer_name is '付款人名称';
comment on column ${iml_schema}.agt_secd_pay_sign_agt_h.payer_acct_type is '付款人账户类型';
comment on column ${iml_schema}.agt_secd_pay_sign_agt_h.payer_open_bank_num is '付款人开户行号';
comment on column ${iml_schema}.agt_secd_pay_sign_agt_h.pay_bank_bank_no is '付款行行号';
comment on column ${iml_schema}.agt_secd_pay_sign_agt_h.pay_bank_name is '付款行名称';
comment on column ${iml_schema}.agt_secd_pay_sign_agt_h.once_deduct_lmt is '一次性扣款限额';
comment on column ${iml_schema}.agt_secd_pay_sign_agt_h.deduct_ped_int_lmt_cnt is '扣款周期内限制笔数';
comment on column ${iml_schema}.agt_secd_pay_sign_agt_h.deduct_ped_inner_buckle_fee_lmt is '扣款周期内扣费限额';
comment on column ${iml_schema}.agt_secd_pay_sign_agt_h.deduct_tm_corp is '扣款时间单位';
comment on column ${iml_schema}.agt_secd_pay_sign_agt_h.deduct_tm_length is '扣款时间长度';
comment on column ${iml_schema}.agt_secd_pay_sign_agt_h.deduct_tm_descb is '扣款时间描述';
comment on column ${iml_schema}.agt_secd_pay_sign_agt_h.addit_info is '附加信息';
comment on column ${iml_schema}.agt_secd_pay_sign_agt_h.err_info_desc is '错误信息描述';
comment on column ${iml_schema}.agt_secd_pay_sign_agt_h.auth_mode_cd is '授权模式代码';
comment on column ${iml_schema}.agt_secd_pay_sign_agt_h.postsc is '附言';
comment on column ${iml_schema}.agt_secd_pay_sign_agt_h.whole_proc_idf is '全行处理标识';
comment on column ${iml_schema}.agt_secd_pay_sign_agt_h.open_acct_org_id is '开户机构编号';
comment on column ${iml_schema}.agt_secd_pay_sign_agt_h.tran_org_id is '交易机构编号';
comment on column ${iml_schema}.agt_secd_pay_sign_agt_h.proc_org_id is '处理机构编号';
comment on column ${iml_schema}.agt_secd_pay_sign_agt_h.tran_teller_id is '交易柜员编号';
comment on column ${iml_schema}.agt_secd_pay_sign_agt_h.auth_teller_id is '授权柜员编号';
comment on column ${iml_schema}.agt_secd_pay_sign_agt_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_secd_pay_sign_agt_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_secd_pay_sign_agt_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_secd_pay_sign_agt_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_secd_pay_sign_agt_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_secd_pay_sign_agt_h.etl_timestamp is 'ETL处理时间戳';
