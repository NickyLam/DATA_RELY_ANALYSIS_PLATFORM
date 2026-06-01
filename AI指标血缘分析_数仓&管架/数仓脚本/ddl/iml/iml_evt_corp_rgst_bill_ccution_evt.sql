/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_corp_rgst_bill_ccution_evt
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_corp_rgst_bill_ccution_evt
whenever sqlerror continue none;
drop table ${iml_schema}.evt_corp_rgst_bill_ccution_evt purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_corp_rgst_bill_ccution_evt(
    evt_id varchar2(100) -- 事件编号
    ,lp_id varchar2(60) -- 法人编号
    ,rgst_id varchar2(60) -- 登记编号
    ,bill_id varchar2(60) -- 票据编号
    ,recv_id varchar2(60) -- 签收编号
    ,prod_id varchar2(60) -- 产品编号
    ,prod_name varchar2(375) -- 产品名称
    ,bill_med_cd varchar2(10) -- 票据介质代码
    ,bill_type_cd varchar2(10) -- 票据类型代码
    ,bus_type_cd varchar2(10) -- 业务类型代码
    ,bus_attr_cd varchar2(10) -- 业务属性代码
    ,bus_dir_cd varchar2(10) -- 业务方向代码
    ,bill_src_cd varchar2(10) -- 票据来源代码
    ,bill_num varchar2(60) -- 票据号码
    ,bill_sub_intrv_id varchar2(60) -- 票据子区间编号
    ,bill_amt number(30,2) -- 票据金额
    ,tran_dt date -- 交易日期
    ,reqer_type_cd varchar2(10) -- 请求方类型代码
    ,reqer_name varchar2(375) -- 请求方名称
    ,reqer_soci_crdt_cd varchar2(30) -- 请求方社会信用代码
    ,reqer_acct_type_cd varchar2(10) -- 请求方账户类型代码
    ,reqer_acct_id varchar2(60) -- 请求方账户编号
    ,reqer_acct_name varchar2(750) -- 请求方账户名称
    ,reqer_open_bank_no varchar2(30) -- 请求方开户行行号
    ,reqer_mem_cd varchar2(30) -- 请求方会员代码
    ,reqer_org_cd varchar2(30) -- 请求方机构代码
    ,recver_type_cd varchar2(10) -- 接收方类型代码
    ,recver_name varchar2(375) -- 接收方名称
    ,recver_soci_crdt_cd varchar2(30) -- 接收方社会信用代码
    ,recver_acct_type_cd varchar2(10) -- 接收方账户类型代码
    ,recver_acct_id varchar2(60) -- 接收方账户编号
    ,recver_acct_name varchar2(750) -- 接收方账户名称
    ,recver_open_bank_no varchar2(30) -- 接收方开户行行号
    ,recver_mem_cd varchar2(30) -- 接收方会员代码
    ,recver_org_cd varchar2(30) -- 接收方机构代码
    ,discnt_int_rat number(18,8) -- 贴现利率
    ,discnt_actl_amt number(30,2) -- 贴现实付金额
    ,not_ngbl_cd varchar2(10) -- 不得转让代码
    ,onl_clear_flg varchar2(10) -- 线上清算标志
    ,enter_id varchar2(60) -- 入账账户编号
    ,enter_acct_bank_no varchar2(30) -- 入账行号
    ,reply_idf_cd varchar2(10) -- 应答标识代码
    ,recv_dt date -- 签收日期
    ,refuse_pay_cd varchar2(10) -- 拒付代码
    ,refuse_pay_remark_info varchar2(750) -- 拒付备注信息
    ,recs_type_cd varchar2(10) -- 追偿类型代码
    ,actl_int number(30,2) -- 实付利息
    ,int_accr_exp_dt date -- 计息到期日期
    ,int_payer_name varchar2(375) -- 付息人名称
    ,int_payer_acct_id varchar2(60) -- 付息人账户编号
    ,int_payer_open_bank_name varchar2(375) -- 付息人开户行名称
    ,comm_fee number(30,2) -- 手续费
    ,todos number(30,2) -- 工本费
    ,pay_int_ratio number(18,6) -- 付息比例
    ,buyer_pay_int_int number(30,2) -- 买方付息利息
    ,tot_int number(30,2) -- 总利息
    ,stop_pay_type_cd varchar2(10) -- 止付类型代码
    ,stop_pay_rs_descb varchar2(750) -- 止付原因描述
    ,remit_stop_pay_type_cd varchar2(10) -- 解除止付类型代码
    ,remit_stop_pay_rs_descb varchar2(750) -- 解除止付原因描述
    ,surp_tenor number(10) -- 剩余期限
    ,stl_amt number(30,2) -- 结算金额
    ,stl_rest_cd varchar2(10) -- 结算结果代码
    ,stl_dt date -- 结算日期
    ,payoff_type_cd varchar2(10) -- 结清类型代码
    ,tran_status_cd varchar2(10) -- 交易状态代码
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
grant select on ${iml_schema}.evt_corp_rgst_bill_ccution_evt to ${icl_schema};
grant select on ${iml_schema}.evt_corp_rgst_bill_ccution_evt to ${idl_schema};
grant select on ${iml_schema}.evt_corp_rgst_bill_ccution_evt to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_corp_rgst_bill_ccution_evt is '企业登记中心票据流转事件';
comment on column ${iml_schema}.evt_corp_rgst_bill_ccution_evt.evt_id is '事件编号';
comment on column ${iml_schema}.evt_corp_rgst_bill_ccution_evt.lp_id is '法人编号';
comment on column ${iml_schema}.evt_corp_rgst_bill_ccution_evt.rgst_id is '登记编号';
comment on column ${iml_schema}.evt_corp_rgst_bill_ccution_evt.bill_id is '票据编号';
comment on column ${iml_schema}.evt_corp_rgst_bill_ccution_evt.recv_id is '签收编号';
comment on column ${iml_schema}.evt_corp_rgst_bill_ccution_evt.prod_id is '产品编号';
comment on column ${iml_schema}.evt_corp_rgst_bill_ccution_evt.prod_name is '产品名称';
comment on column ${iml_schema}.evt_corp_rgst_bill_ccution_evt.bill_med_cd is '票据介质代码';
comment on column ${iml_schema}.evt_corp_rgst_bill_ccution_evt.bill_type_cd is '票据类型代码';
comment on column ${iml_schema}.evt_corp_rgst_bill_ccution_evt.bus_type_cd is '业务类型代码';
comment on column ${iml_schema}.evt_corp_rgst_bill_ccution_evt.bus_attr_cd is '业务属性代码';
comment on column ${iml_schema}.evt_corp_rgst_bill_ccution_evt.bus_dir_cd is '业务方向代码';
comment on column ${iml_schema}.evt_corp_rgst_bill_ccution_evt.bill_src_cd is '票据来源代码';
comment on column ${iml_schema}.evt_corp_rgst_bill_ccution_evt.bill_num is '票据号码';
comment on column ${iml_schema}.evt_corp_rgst_bill_ccution_evt.bill_sub_intrv_id is '票据子区间编号';
comment on column ${iml_schema}.evt_corp_rgst_bill_ccution_evt.bill_amt is '票据金额';
comment on column ${iml_schema}.evt_corp_rgst_bill_ccution_evt.tran_dt is '交易日期';
comment on column ${iml_schema}.evt_corp_rgst_bill_ccution_evt.reqer_type_cd is '请求方类型代码';
comment on column ${iml_schema}.evt_corp_rgst_bill_ccution_evt.reqer_name is '请求方名称';
comment on column ${iml_schema}.evt_corp_rgst_bill_ccution_evt.reqer_soci_crdt_cd is '请求方社会信用代码';
comment on column ${iml_schema}.evt_corp_rgst_bill_ccution_evt.reqer_acct_type_cd is '请求方账户类型代码';
comment on column ${iml_schema}.evt_corp_rgst_bill_ccution_evt.reqer_acct_id is '请求方账户编号';
comment on column ${iml_schema}.evt_corp_rgst_bill_ccution_evt.reqer_acct_name is '请求方账户名称';
comment on column ${iml_schema}.evt_corp_rgst_bill_ccution_evt.reqer_open_bank_no is '请求方开户行行号';
comment on column ${iml_schema}.evt_corp_rgst_bill_ccution_evt.reqer_mem_cd is '请求方会员代码';
comment on column ${iml_schema}.evt_corp_rgst_bill_ccution_evt.reqer_org_cd is '请求方机构代码';
comment on column ${iml_schema}.evt_corp_rgst_bill_ccution_evt.recver_type_cd is '接收方类型代码';
comment on column ${iml_schema}.evt_corp_rgst_bill_ccution_evt.recver_name is '接收方名称';
comment on column ${iml_schema}.evt_corp_rgst_bill_ccution_evt.recver_soci_crdt_cd is '接收方社会信用代码';
comment on column ${iml_schema}.evt_corp_rgst_bill_ccution_evt.recver_acct_type_cd is '接收方账户类型代码';
comment on column ${iml_schema}.evt_corp_rgst_bill_ccution_evt.recver_acct_id is '接收方账户编号';
comment on column ${iml_schema}.evt_corp_rgst_bill_ccution_evt.recver_acct_name is '接收方账户名称';
comment on column ${iml_schema}.evt_corp_rgst_bill_ccution_evt.recver_open_bank_no is '接收方开户行行号';
comment on column ${iml_schema}.evt_corp_rgst_bill_ccution_evt.recver_mem_cd is '接收方会员代码';
comment on column ${iml_schema}.evt_corp_rgst_bill_ccution_evt.recver_org_cd is '接收方机构代码';
comment on column ${iml_schema}.evt_corp_rgst_bill_ccution_evt.discnt_int_rat is '贴现利率';
comment on column ${iml_schema}.evt_corp_rgst_bill_ccution_evt.discnt_actl_amt is '贴现实付金额';
comment on column ${iml_schema}.evt_corp_rgst_bill_ccution_evt.not_ngbl_cd is '不得转让代码';
comment on column ${iml_schema}.evt_corp_rgst_bill_ccution_evt.onl_clear_flg is '线上清算标志';
comment on column ${iml_schema}.evt_corp_rgst_bill_ccution_evt.enter_id is '入账账户编号';
comment on column ${iml_schema}.evt_corp_rgst_bill_ccution_evt.enter_acct_bank_no is '入账行号';
comment on column ${iml_schema}.evt_corp_rgst_bill_ccution_evt.reply_idf_cd is '应答标识代码';
comment on column ${iml_schema}.evt_corp_rgst_bill_ccution_evt.recv_dt is '签收日期';
comment on column ${iml_schema}.evt_corp_rgst_bill_ccution_evt.refuse_pay_cd is '拒付代码';
comment on column ${iml_schema}.evt_corp_rgst_bill_ccution_evt.refuse_pay_remark_info is '拒付备注信息';
comment on column ${iml_schema}.evt_corp_rgst_bill_ccution_evt.recs_type_cd is '追偿类型代码';
comment on column ${iml_schema}.evt_corp_rgst_bill_ccution_evt.actl_int is '实付利息';
comment on column ${iml_schema}.evt_corp_rgst_bill_ccution_evt.int_accr_exp_dt is '计息到期日期';
comment on column ${iml_schema}.evt_corp_rgst_bill_ccution_evt.int_payer_name is '付息人名称';
comment on column ${iml_schema}.evt_corp_rgst_bill_ccution_evt.int_payer_acct_id is '付息人账户编号';
comment on column ${iml_schema}.evt_corp_rgst_bill_ccution_evt.int_payer_open_bank_name is '付息人开户行名称';
comment on column ${iml_schema}.evt_corp_rgst_bill_ccution_evt.comm_fee is '手续费';
comment on column ${iml_schema}.evt_corp_rgst_bill_ccution_evt.todos is '工本费';
comment on column ${iml_schema}.evt_corp_rgst_bill_ccution_evt.pay_int_ratio is '付息比例';
comment on column ${iml_schema}.evt_corp_rgst_bill_ccution_evt.buyer_pay_int_int is '买方付息利息';
comment on column ${iml_schema}.evt_corp_rgst_bill_ccution_evt.tot_int is '总利息';
comment on column ${iml_schema}.evt_corp_rgst_bill_ccution_evt.stop_pay_type_cd is '止付类型代码';
comment on column ${iml_schema}.evt_corp_rgst_bill_ccution_evt.stop_pay_rs_descb is '止付原因描述';
comment on column ${iml_schema}.evt_corp_rgst_bill_ccution_evt.remit_stop_pay_type_cd is '解除止付类型代码';
comment on column ${iml_schema}.evt_corp_rgst_bill_ccution_evt.remit_stop_pay_rs_descb is '解除止付原因描述';
comment on column ${iml_schema}.evt_corp_rgst_bill_ccution_evt.surp_tenor is '剩余期限';
comment on column ${iml_schema}.evt_corp_rgst_bill_ccution_evt.stl_amt is '结算金额';
comment on column ${iml_schema}.evt_corp_rgst_bill_ccution_evt.stl_rest_cd is '结算结果代码';
comment on column ${iml_schema}.evt_corp_rgst_bill_ccution_evt.stl_dt is '结算日期';
comment on column ${iml_schema}.evt_corp_rgst_bill_ccution_evt.payoff_type_cd is '结清类型代码';
comment on column ${iml_schema}.evt_corp_rgst_bill_ccution_evt.tran_status_cd is '交易状态代码';
comment on column ${iml_schema}.evt_corp_rgst_bill_ccution_evt.start_dt is '开始时间';
comment on column ${iml_schema}.evt_corp_rgst_bill_ccution_evt.end_dt is '结束时间';
comment on column ${iml_schema}.evt_corp_rgst_bill_ccution_evt.id_mark is '增删标志';
comment on column ${iml_schema}.evt_corp_rgst_bill_ccution_evt.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_corp_rgst_bill_ccution_evt.job_cd is '任务编码';
comment on column ${iml_schema}.evt_corp_rgst_bill_ccution_evt.etl_timestamp is 'ETL处理时间戳';
