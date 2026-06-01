/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_fft_tran_dtl
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_fft_tran_dtl
whenever sqlerror continue none;
drop table ${iml_schema}.agt_fft_tran_dtl purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_fft_tran_dtl(
    agt_id varchar2(250) -- 协议编号
    ,lp_id varchar2(100) -- 法人编号
    ,flow_num varchar2(100) -- 流水号
    ,tot_flow_num varchar2(100) -- 汇总流水号
    ,dubil_id varchar2(100) -- 借据编号
    ,sell_int_rat number(18,8) -- 卖出利率
    ,tran_sell_recvbl_amt number(30,8) -- 转卖收款金额
    ,abmt_comm_fee_amt number(30,8) -- 汇入手续费金额
    ,tran_sell_exp_dt date -- 转卖到期日期
    ,amorted_amt number(30,8) -- 待摊金额
    ,inter_bus_inco_amt number(30,8) -- 中间业务收入金额
    ,issue_bank_bank_no varchar2(60) -- 开证行行号
    ,acpt_bank_bank_no varchar2(60) -- 承兑行行号
    ,lc_benefc_indus_type_cd varchar2(30) -- 信用证受益人行业类型代码
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
grant select on ${iml_schema}.agt_fft_tran_dtl to ${icl_schema};
grant select on ${iml_schema}.agt_fft_tran_dtl to ${idl_schema};
grant select on ${iml_schema}.agt_fft_tran_dtl to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_fft_tran_dtl is '福费廷转让明细';
comment on column ${iml_schema}.agt_fft_tran_dtl.agt_id is '协议编号';
comment on column ${iml_schema}.agt_fft_tran_dtl.lp_id is '法人编号';
comment on column ${iml_schema}.agt_fft_tran_dtl.flow_num is '流水号';
comment on column ${iml_schema}.agt_fft_tran_dtl.tot_flow_num is '汇总流水号';
comment on column ${iml_schema}.agt_fft_tran_dtl.dubil_id is '借据编号';
comment on column ${iml_schema}.agt_fft_tran_dtl.sell_int_rat is '卖出利率';
comment on column ${iml_schema}.agt_fft_tran_dtl.tran_sell_recvbl_amt is '转卖收款金额';
comment on column ${iml_schema}.agt_fft_tran_dtl.abmt_comm_fee_amt is '汇入手续费金额';
comment on column ${iml_schema}.agt_fft_tran_dtl.tran_sell_exp_dt is '转卖到期日期';
comment on column ${iml_schema}.agt_fft_tran_dtl.amorted_amt is '待摊金额';
comment on column ${iml_schema}.agt_fft_tran_dtl.inter_bus_inco_amt is '中间业务收入金额';
comment on column ${iml_schema}.agt_fft_tran_dtl.issue_bank_bank_no is '开证行行号';
comment on column ${iml_schema}.agt_fft_tran_dtl.acpt_bank_bank_no is '承兑行行号';
comment on column ${iml_schema}.agt_fft_tran_dtl.lc_benefc_indus_type_cd is '信用证受益人行业类型代码';
comment on column ${iml_schema}.agt_fft_tran_dtl.start_dt is '开始时间';
comment on column ${iml_schema}.agt_fft_tran_dtl.end_dt is '结束时间';
comment on column ${iml_schema}.agt_fft_tran_dtl.id_mark is '增删标志';
comment on column ${iml_schema}.agt_fft_tran_dtl.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_fft_tran_dtl.job_cd is '任务编码';
comment on column ${iml_schema}.agt_fft_tran_dtl.etl_timestamp is 'ETL处理时间戳';
