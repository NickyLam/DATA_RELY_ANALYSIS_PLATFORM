/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_fft_tran_tot_tab
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_fft_tran_tot_tab
whenever sqlerror continue none;
drop table ${iml_schema}.agt_fft_tran_tot_tab purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_fft_tran_tot_tab(
    agt_id varchar2(250) -- 协议编号
    ,lp_id varchar2(100) -- 法人编号
    ,flow_num varchar2(100) -- 流水号
    ,cntpty_id varchar2(100) -- 交易对手编号
    ,cntpty_name varchar2(500) -- 交易对手名称
    ,dubil_cnt number(10) -- 借据笔数
    ,tran_sell_recvbl_amt_tot number(30,8) -- 转卖收款金额汇总
    ,tran_sell_dubil_amt_tot number(30,8) -- 转卖借据金额汇总
    ,recvbl_acct_id varchar2(100) -- 收款账户编号
    ,ts_flg varchar2(10) -- 暂存标志
    ,tran_comnt varchar2(500) -- 转让说明
    ,cap_src_acct_id varchar2(100) -- 资金来源账户编号
    ,cap_src_acct_name varchar2(500) -- 资金来源账户名称
    ,cap_src_bank_no varchar2(100) -- 资金来源行号
    ,cap_src_bank_name varchar2(500) -- 资金来源行名称
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
grant select on ${iml_schema}.agt_fft_tran_tot_tab to ${icl_schema};
grant select on ${iml_schema}.agt_fft_tran_tot_tab to ${idl_schema};
grant select on ${iml_schema}.agt_fft_tran_tot_tab to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_fft_tran_tot_tab is '福费廷转让汇总表';
comment on column ${iml_schema}.agt_fft_tran_tot_tab.agt_id is '协议编号';
comment on column ${iml_schema}.agt_fft_tran_tot_tab.lp_id is '法人编号';
comment on column ${iml_schema}.agt_fft_tran_tot_tab.flow_num is '流水号';
comment on column ${iml_schema}.agt_fft_tran_tot_tab.cntpty_id is '交易对手编号';
comment on column ${iml_schema}.agt_fft_tran_tot_tab.cntpty_name is '交易对手名称';
comment on column ${iml_schema}.agt_fft_tran_tot_tab.dubil_cnt is '借据笔数';
comment on column ${iml_schema}.agt_fft_tran_tot_tab.tran_sell_recvbl_amt_tot is '转卖收款金额汇总';
comment on column ${iml_schema}.agt_fft_tran_tot_tab.tran_sell_dubil_amt_tot is '转卖借据金额汇总';
comment on column ${iml_schema}.agt_fft_tran_tot_tab.recvbl_acct_id is '收款账户编号';
comment on column ${iml_schema}.agt_fft_tran_tot_tab.ts_flg is '暂存标志';
comment on column ${iml_schema}.agt_fft_tran_tot_tab.tran_comnt is '转让说明';
comment on column ${iml_schema}.agt_fft_tran_tot_tab.cap_src_acct_id is '资金来源账户编号';
comment on column ${iml_schema}.agt_fft_tran_tot_tab.cap_src_acct_name is '资金来源账户名称';
comment on column ${iml_schema}.agt_fft_tran_tot_tab.cap_src_bank_no is '资金来源行号';
comment on column ${iml_schema}.agt_fft_tran_tot_tab.cap_src_bank_name is '资金来源行名称';
comment on column ${iml_schema}.agt_fft_tran_tot_tab.start_dt is '开始时间';
comment on column ${iml_schema}.agt_fft_tran_tot_tab.end_dt is '结束时间';
comment on column ${iml_schema}.agt_fft_tran_tot_tab.id_mark is '增删标志';
comment on column ${iml_schema}.agt_fft_tran_tot_tab.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_fft_tran_tot_tab.job_cd is '任务编码';
comment on column ${iml_schema}.agt_fft_tran_tot_tab.etl_timestamp is 'ETL处理时间戳';
