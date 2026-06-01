/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_bill_adv_and_ovdue_redem_batch
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_bill_adv_and_ovdue_redem_batch
whenever sqlerror continue none;
drop table ${iml_schema}.evt_bill_adv_and_ovdue_redem_batch purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_bill_adv_and_ovdue_redem_batch(
    evt_id varchar2(100) -- 事件编号
    ,lp_id varchar2(60) -- 法人编号
    ,appl_batch_ser_num varchar2(100) -- 申请批次序列号
    ,redem_task_ser_num varchar2(100) -- 赎回任务序列号
    ,batch_id varchar2(100) -- 批次编号
    ,dial_quot_batch_ser_num varchar2(100) -- 对话报价批次序列号
    ,init_bus_lmt_ocup_status_cd varchar2(30) -- 原业务额度占用状态代码
    ,prod_id varchar2(100) -- 产品编号
    ,bus_type_cd varchar2(30) -- 业务类型代码
    ,hq_org_id varchar2(100) -- 总行机构编号
    ,org_id varchar2(100) -- 机构编号
    ,appl_dt date -- 申请日期
    ,ghb_org_name varchar2(300) -- 本方机构名称
    ,ghb_org_id varchar2(100) -- 本方机构编号
    ,cntpty_name varchar2(375) -- 交易对手名称
    ,cntpty_org_id varchar2(200) -- 交易对手行号
    ,cntpty_bank_id varchar2(200) -- 交易对手银行编号
    ,cntpty_non_lp_prod_id varchar2(200) -- 交易对手非法人产品编号
    ,ctr_nt_id varchar2(200) -- 成交单编号
    ,redem_cate_cd varchar2(30) -- 赎回类别代码
    ,redem_ar_cd varchar2(30) -- 赎回事由代码
    ,redem_rest_cd varchar2(30) -- 赎回结果代码
    ,redem_intior_proc_opinion_descb varchar2(300) -- 赎回发起方处理意见描述
    ,redem_recv_proc_opinion_descb varchar2(300) -- 赎回签收方处理意见描述
    ,redem_intior_remark_descb varchar2(750) -- 赎回发起方备注描述
    ,redem_recv_remark_descb varchar2(750) -- 赎回签收方备注描述
    ,fs_proc_rest_cd varchar2(30) -- 场务处理结果代码
    ,fs_proc_opinion_descb varchar2(300) -- 场务处理意见描述
    ,reply_idfg_cd varchar2(30) -- 应答标识代码
    ,dept_id varchar2(100) -- 部门编号
    ,cust_mgr_id varchar2(100) -- 客户经理编号
    ,bill_med_cd varchar2(30) -- 票据介质代码
    ,bill_type_cd varchar2(30) -- 票据类型代码
    ,bill_tot_amt number(30,2) -- 票据总金额
    ,bill_cnt number(10) -- 票据张数
    ,init_bus_repo_amt number(30,2) -- 原业务回购金额
    ,fst_stl_amt number(30,2) -- 首期结算金额
    ,redem_stl_amt number(30,2) -- 赎回结算金额
    ,repo_int_rat number(18,8) -- 回购利率
    ,init_bus_int_paybl number(30,2) -- 原业务应付利息
    ,redem_int_paybl number(30,2) -- 赎回应付利息
    ,repo_yld_rat number(18,8) -- 回购收益率
    ,init_bus_fst_stl_amt date -- 原业务首期结算日期
    ,init_bus_exp_stl_dt date -- 原业务到期结算日期
    ,lmt_ocup_status_cd varchar2(30) -- 额度占用状态代码
    ,apv_status_cd varchar2(30) -- 审批状态代码
    ,entry_status_cd varchar2(30) -- 记账状态代码
    ,valid_flg varchar2(10) -- 有效标志
    ,msg_proc_status_cd varchar2(30) -- 报文处理状态代码
    ,clear_status_cd varchar2(30) -- 清算状态代码
    ,final_modif_operr_id varchar2(100) -- 最后修改操作员编号
    ,final_modif_tm timestamp -- 最后修改时间
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
grant select on ${iml_schema}.evt_bill_adv_and_ovdue_redem_batch to ${icl_schema};
grant select on ${iml_schema}.evt_bill_adv_and_ovdue_redem_batch to ${idl_schema};
grant select on ${iml_schema}.evt_bill_adv_and_ovdue_redem_batch to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_bill_adv_and_ovdue_redem_batch is '票据提前和逾期赎回批次';
comment on column ${iml_schema}.evt_bill_adv_and_ovdue_redem_batch.evt_id is '事件编号';
comment on column ${iml_schema}.evt_bill_adv_and_ovdue_redem_batch.lp_id is '法人编号';
comment on column ${iml_schema}.evt_bill_adv_and_ovdue_redem_batch.appl_batch_ser_num is '申请批次序列号';
comment on column ${iml_schema}.evt_bill_adv_and_ovdue_redem_batch.redem_task_ser_num is '赎回任务序列号';
comment on column ${iml_schema}.evt_bill_adv_and_ovdue_redem_batch.batch_id is '批次编号';
comment on column ${iml_schema}.evt_bill_adv_and_ovdue_redem_batch.dial_quot_batch_ser_num is '对话报价批次序列号';
comment on column ${iml_schema}.evt_bill_adv_and_ovdue_redem_batch.init_bus_lmt_ocup_status_cd is '原业务额度占用状态代码';
comment on column ${iml_schema}.evt_bill_adv_and_ovdue_redem_batch.prod_id is '产品编号';
comment on column ${iml_schema}.evt_bill_adv_and_ovdue_redem_batch.bus_type_cd is '业务类型代码';
comment on column ${iml_schema}.evt_bill_adv_and_ovdue_redem_batch.hq_org_id is '总行机构编号';
comment on column ${iml_schema}.evt_bill_adv_and_ovdue_redem_batch.org_id is '机构编号';
comment on column ${iml_schema}.evt_bill_adv_and_ovdue_redem_batch.appl_dt is '申请日期';
comment on column ${iml_schema}.evt_bill_adv_and_ovdue_redem_batch.ghb_org_name is '本方机构名称';
comment on column ${iml_schema}.evt_bill_adv_and_ovdue_redem_batch.ghb_org_id is '本方机构编号';
comment on column ${iml_schema}.evt_bill_adv_and_ovdue_redem_batch.cntpty_name is '交易对手名称';
comment on column ${iml_schema}.evt_bill_adv_and_ovdue_redem_batch.cntpty_org_id is '交易对手行号';
comment on column ${iml_schema}.evt_bill_adv_and_ovdue_redem_batch.cntpty_bank_id is '交易对手银行编号';
comment on column ${iml_schema}.evt_bill_adv_and_ovdue_redem_batch.cntpty_non_lp_prod_id is '交易对手非法人产品编号';
comment on column ${iml_schema}.evt_bill_adv_and_ovdue_redem_batch.ctr_nt_id is '成交单编号';
comment on column ${iml_schema}.evt_bill_adv_and_ovdue_redem_batch.redem_cate_cd is '赎回类别代码';
comment on column ${iml_schema}.evt_bill_adv_and_ovdue_redem_batch.redem_ar_cd is '赎回事由代码';
comment on column ${iml_schema}.evt_bill_adv_and_ovdue_redem_batch.redem_rest_cd is '赎回结果代码';
comment on column ${iml_schema}.evt_bill_adv_and_ovdue_redem_batch.redem_intior_proc_opinion_descb is '赎回发起方处理意见描述';
comment on column ${iml_schema}.evt_bill_adv_and_ovdue_redem_batch.redem_recv_proc_opinion_descb is '赎回签收方处理意见描述';
comment on column ${iml_schema}.evt_bill_adv_and_ovdue_redem_batch.redem_intior_remark_descb is '赎回发起方备注描述';
comment on column ${iml_schema}.evt_bill_adv_and_ovdue_redem_batch.redem_recv_remark_descb is '赎回签收方备注描述';
comment on column ${iml_schema}.evt_bill_adv_and_ovdue_redem_batch.fs_proc_rest_cd is '场务处理结果代码';
comment on column ${iml_schema}.evt_bill_adv_and_ovdue_redem_batch.fs_proc_opinion_descb is '场务处理意见描述';
comment on column ${iml_schema}.evt_bill_adv_and_ovdue_redem_batch.reply_idfg_cd is '应答标识代码';
comment on column ${iml_schema}.evt_bill_adv_and_ovdue_redem_batch.dept_id is '部门编号';
comment on column ${iml_schema}.evt_bill_adv_and_ovdue_redem_batch.cust_mgr_id is '客户经理编号';
comment on column ${iml_schema}.evt_bill_adv_and_ovdue_redem_batch.bill_med_cd is '票据介质代码';
comment on column ${iml_schema}.evt_bill_adv_and_ovdue_redem_batch.bill_type_cd is '票据类型代码';
comment on column ${iml_schema}.evt_bill_adv_and_ovdue_redem_batch.bill_tot_amt is '票据总金额';
comment on column ${iml_schema}.evt_bill_adv_and_ovdue_redem_batch.bill_cnt is '票据张数';
comment on column ${iml_schema}.evt_bill_adv_and_ovdue_redem_batch.init_bus_repo_amt is '原业务回购金额';
comment on column ${iml_schema}.evt_bill_adv_and_ovdue_redem_batch.fst_stl_amt is '首期结算金额';
comment on column ${iml_schema}.evt_bill_adv_and_ovdue_redem_batch.redem_stl_amt is '赎回结算金额';
comment on column ${iml_schema}.evt_bill_adv_and_ovdue_redem_batch.repo_int_rat is '回购利率';
comment on column ${iml_schema}.evt_bill_adv_and_ovdue_redem_batch.init_bus_int_paybl is '原业务应付利息';
comment on column ${iml_schema}.evt_bill_adv_and_ovdue_redem_batch.redem_int_paybl is '赎回应付利息';
comment on column ${iml_schema}.evt_bill_adv_and_ovdue_redem_batch.repo_yld_rat is '回购收益率';
comment on column ${iml_schema}.evt_bill_adv_and_ovdue_redem_batch.init_bus_fst_stl_amt is '原业务首期结算日期';
comment on column ${iml_schema}.evt_bill_adv_and_ovdue_redem_batch.init_bus_exp_stl_dt is '原业务到期结算日期';
comment on column ${iml_schema}.evt_bill_adv_and_ovdue_redem_batch.lmt_ocup_status_cd is '额度占用状态代码';
comment on column ${iml_schema}.evt_bill_adv_and_ovdue_redem_batch.apv_status_cd is '审批状态代码';
comment on column ${iml_schema}.evt_bill_adv_and_ovdue_redem_batch.entry_status_cd is '记账状态代码';
comment on column ${iml_schema}.evt_bill_adv_and_ovdue_redem_batch.valid_flg is '有效标志';
comment on column ${iml_schema}.evt_bill_adv_and_ovdue_redem_batch.msg_proc_status_cd is '报文处理状态代码';
comment on column ${iml_schema}.evt_bill_adv_and_ovdue_redem_batch.clear_status_cd is '清算状态代码';
comment on column ${iml_schema}.evt_bill_adv_and_ovdue_redem_batch.final_modif_operr_id is '最后修改操作员编号';
comment on column ${iml_schema}.evt_bill_adv_and_ovdue_redem_batch.final_modif_tm is '最后修改时间';
comment on column ${iml_schema}.evt_bill_adv_and_ovdue_redem_batch.start_dt is '开始时间';
comment on column ${iml_schema}.evt_bill_adv_and_ovdue_redem_batch.end_dt is '结束时间';
comment on column ${iml_schema}.evt_bill_adv_and_ovdue_redem_batch.id_mark is '增删标志';
comment on column ${iml_schema}.evt_bill_adv_and_ovdue_redem_batch.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_bill_adv_and_ovdue_redem_batch.job_cd is '任务编码';
comment on column ${iml_schema}.evt_bill_adv_and_ovdue_redem_batch.etl_timestamp is 'ETL处理时间戳';
