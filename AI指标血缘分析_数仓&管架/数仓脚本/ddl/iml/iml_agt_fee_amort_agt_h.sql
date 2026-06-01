/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_fee_amort_agt_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_fee_amort_agt_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_fee_amort_agt_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_fee_amort_agt_h(
    agt_id varchar2(250) -- 协议编号
    ,lp_id varchar2(100) -- 法人编号
    ,src_agt_id varchar2(100) -- 源协议编号
    ,cust_id varchar2(100) -- 客户编号
    ,cont_id varchar2(100) -- 合同编号
    ,acct_id varchar2(100) -- 账户编号
    ,tran_ref_no varchar2(60) -- 交易参考号
    ,ova_flow_num varchar2(100) -- 全局流水号
    ,bus_flow_num varchar2(100) -- 业务流水号
    ,check_entry_cd varchar2(30) -- 对账代码
    ,tran_code varchar2(30) -- 交易码
    ,fee_type_cd varchar2(30) -- 费用类型代码
    ,amort_status_cd varchar2(30) -- 摊销状态代码
    ,amort_name varchar2(500) -- 摊销名称
    ,amort_tm_type_cd varchar2(30) -- 摊销时间类型代码
    ,amort_tot_cnt number(10) -- 摊销总次数
    ,amorted_cnt number(10) -- 已摊销次数
    ,surp_amort_cnt number(10) -- 剩余摊销次数
    ,last_amort_dt date -- 上一摊销日期
    ,next_amort_dt date -- 下一摊销日期
    ,amort_curr_cd varchar2(30) -- 摊销币种代码
    ,amort_tenor_type_cd varchar2(30) -- 摊销期限类型代码
    ,amort_mon varchar2(10) -- 摊销月
    ,amort_day varchar2(10) -- 摊销日
    ,amort_tot_amt number(30,2) -- 摊销总金额
    ,amorted_amt number(30,2) -- 已摊销金额
    ,surp_amort_amt number(30,2) -- 剩余摊销金额
    ,bank_tran_seq_num varchar2(60) -- 银行交易序号
    ,batch_dtl_seq_num varchar2(60) -- 批次明细序号
    ,bus_id varchar2(100) -- 业务编号
    ,coll_flg_cd varchar2(30) -- 收取标志代码
    ,recvbl_fee_seq_num varchar2(60) -- 应收费用序号
    ,src_module_type_cd varchar2(30) -- 源模块类型代码
    ,chn_id varchar2(100) -- 渠道编号
    ,effect_dt date -- 生效日期
    ,invalid_dt date -- 失效日期
    ,tran_revd_flg varchar2(10) -- 交易已冲正标志
    ,revs_auth_teller_id varchar2(100) -- 冲正授权柜员编号
    ,revs_org_id varchar2(100) -- 冲正机构编号
    ,revs_teller_id varchar2(100) -- 冲正柜员编号
    ,revs_dt date -- 冲正日期
    ,teller_id varchar2(100) -- 柜员编号
    ,auth_teller_id varchar2(100) -- 授权柜员编号
    ,tran_org_id varchar2(100) -- 交易机构编号
    ,tran_dt date -- 交易日期
    ,tran_tm timestamp -- 交易时间
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
grant select on ${iml_schema}.agt_fee_amort_agt_h to ${icl_schema};
grant select on ${iml_schema}.agt_fee_amort_agt_h to ${idl_schema};
grant select on ${iml_schema}.agt_fee_amort_agt_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_fee_amort_agt_h is '费用摊销协议历史';
comment on column ${iml_schema}.agt_fee_amort_agt_h.agt_id is '协议编号';
comment on column ${iml_schema}.agt_fee_amort_agt_h.lp_id is '法人编号';
comment on column ${iml_schema}.agt_fee_amort_agt_h.src_agt_id is '源协议编号';
comment on column ${iml_schema}.agt_fee_amort_agt_h.cust_id is '客户编号';
comment on column ${iml_schema}.agt_fee_amort_agt_h.cont_id is '合同编号';
comment on column ${iml_schema}.agt_fee_amort_agt_h.acct_id is '账户编号';
comment on column ${iml_schema}.agt_fee_amort_agt_h.tran_ref_no is '交易参考号';
comment on column ${iml_schema}.agt_fee_amort_agt_h.ova_flow_num is '全局流水号';
comment on column ${iml_schema}.agt_fee_amort_agt_h.bus_flow_num is '业务流水号';
comment on column ${iml_schema}.agt_fee_amort_agt_h.check_entry_cd is '对账代码';
comment on column ${iml_schema}.agt_fee_amort_agt_h.tran_code is '交易码';
comment on column ${iml_schema}.agt_fee_amort_agt_h.fee_type_cd is '费用类型代码';
comment on column ${iml_schema}.agt_fee_amort_agt_h.amort_status_cd is '摊销状态代码';
comment on column ${iml_schema}.agt_fee_amort_agt_h.amort_name is '摊销名称';
comment on column ${iml_schema}.agt_fee_amort_agt_h.amort_tm_type_cd is '摊销时间类型代码';
comment on column ${iml_schema}.agt_fee_amort_agt_h.amort_tot_cnt is '摊销总次数';
comment on column ${iml_schema}.agt_fee_amort_agt_h.amorted_cnt is '已摊销次数';
comment on column ${iml_schema}.agt_fee_amort_agt_h.surp_amort_cnt is '剩余摊销次数';
comment on column ${iml_schema}.agt_fee_amort_agt_h.last_amort_dt is '上一摊销日期';
comment on column ${iml_schema}.agt_fee_amort_agt_h.next_amort_dt is '下一摊销日期';
comment on column ${iml_schema}.agt_fee_amort_agt_h.amort_curr_cd is '摊销币种代码';
comment on column ${iml_schema}.agt_fee_amort_agt_h.amort_tenor_type_cd is '摊销期限类型代码';
comment on column ${iml_schema}.agt_fee_amort_agt_h.amort_mon is '摊销月';
comment on column ${iml_schema}.agt_fee_amort_agt_h.amort_day is '摊销日';
comment on column ${iml_schema}.agt_fee_amort_agt_h.amort_tot_amt is '摊销总金额';
comment on column ${iml_schema}.agt_fee_amort_agt_h.amorted_amt is '已摊销金额';
comment on column ${iml_schema}.agt_fee_amort_agt_h.surp_amort_amt is '剩余摊销金额';
comment on column ${iml_schema}.agt_fee_amort_agt_h.bank_tran_seq_num is '银行交易序号';
comment on column ${iml_schema}.agt_fee_amort_agt_h.batch_dtl_seq_num is '批次明细序号';
comment on column ${iml_schema}.agt_fee_amort_agt_h.bus_id is '业务编号';
comment on column ${iml_schema}.agt_fee_amort_agt_h.coll_flg_cd is '收取标志代码';
comment on column ${iml_schema}.agt_fee_amort_agt_h.recvbl_fee_seq_num is '应收费用序号';
comment on column ${iml_schema}.agt_fee_amort_agt_h.src_module_type_cd is '源模块类型代码';
comment on column ${iml_schema}.agt_fee_amort_agt_h.chn_id is '渠道编号';
comment on column ${iml_schema}.agt_fee_amort_agt_h.effect_dt is '生效日期';
comment on column ${iml_schema}.agt_fee_amort_agt_h.invalid_dt is '失效日期';
comment on column ${iml_schema}.agt_fee_amort_agt_h.tran_revd_flg is '交易已冲正标志';
comment on column ${iml_schema}.agt_fee_amort_agt_h.revs_auth_teller_id is '冲正授权柜员编号';
comment on column ${iml_schema}.agt_fee_amort_agt_h.revs_org_id is '冲正机构编号';
comment on column ${iml_schema}.agt_fee_amort_agt_h.revs_teller_id is '冲正柜员编号';
comment on column ${iml_schema}.agt_fee_amort_agt_h.revs_dt is '冲正日期';
comment on column ${iml_schema}.agt_fee_amort_agt_h.teller_id is '柜员编号';
comment on column ${iml_schema}.agt_fee_amort_agt_h.auth_teller_id is '授权柜员编号';
comment on column ${iml_schema}.agt_fee_amort_agt_h.tran_org_id is '交易机构编号';
comment on column ${iml_schema}.agt_fee_amort_agt_h.tran_dt is '交易日期';
comment on column ${iml_schema}.agt_fee_amort_agt_h.tran_tm is '交易时间';
comment on column ${iml_schema}.agt_fee_amort_agt_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_fee_amort_agt_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_fee_amort_agt_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_fee_amort_agt_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_fee_amort_agt_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_fee_amort_agt_h.etl_timestamp is 'ETL处理时间戳';
