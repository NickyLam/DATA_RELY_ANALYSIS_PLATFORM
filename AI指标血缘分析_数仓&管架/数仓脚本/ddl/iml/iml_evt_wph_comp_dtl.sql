/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_wph_comp_dtl
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_wph_comp_dtl
whenever sqlerror continue none;
drop table ${iml_schema}.evt_wph_comp_dtl purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_wph_comp_dtl(
    evt_id varchar2(250) -- 事件编号
    ,lp_id varchar2(100) -- 法人编号
    ,repay_flow_num varchar2(100) -- 还款流水号
    ,tran_dt date -- 交易日期
    ,dubil_id varchar2(100) -- 借据编号
    ,ths_tm_comp_perds number(10) -- 本次代偿期数
    ,prod_id varchar2(100) -- 产品编号
    ,curr_cd varchar2(30) -- 币种代码
    ,fin_guar_mode_cd varchar2(30) -- 融担模式代码
    ,repaybl_dt date -- 应还款日期
    ,actl_repay_dt date -- 实际还款日期
    ,ovdue_days number(10) -- 贷款逾期天数
    ,comp_dt date -- 代偿日期
    ,ths_tm_comp_tot_invtor number(30,2) -- 本次代偿总额_资金方
    ,ths_tm_comp_pric_invtor number(30,2) -- 本次代偿本金_资金方
    ,ths_tm_comp_int_invtor number(30,2) -- 本次代偿利息_资金方
    ,ths_tm_comp_pnlt_invtor number(30,2) -- 本次代偿罚息_资金方
    ,ths_tm_comp_comp_int_invtor number(30,2) -- 本次代偿复利_资金方
    ,ths_tm_comp_tot_fubon number(30,2) -- 本次代偿总额_唯品富邦
    ,ths_tm_comp_pric_fubon number(30,2) -- 本次代偿本金_唯品富邦
    ,ths_tm_comp_int_fubon number(30,2) -- 本次代偿利息_唯品富邦
    ,ths_tm_comp_pnlt_fubon number(30,2) -- 本次代偿罚息_唯品富邦
    ,ths_tm_comp_comp_int_fubon number(30,2) -- 本次代偿复利_唯品富邦
    ,fst_guar_id varchar2(100) -- 第一担保编号
    ,fst_guar_ratio number(18,6) -- 第一担保比例
    ,fst_guar_comp_tot_invtor number(30,2) -- 第一担保代偿总额_资金方
    ,fst_guar_comp_pric_invtor number(30,2) -- 第一担保代偿本金_资金方
    ,fst_guar_comp_int_invtor number(30,2) -- 第一担保代偿利息_资金方
    ,fst_guar_comp_pnlt_invtor number(30,2) -- 第一担保代偿罚息_资金方
    ,fst_guar_comp_comp_int_invtor number(30,2) -- 第一担保代偿复利_资金方
    ,fst_guar_comp_tot_fubon number(30,2) -- 第一担保代偿总额_唯品富邦
    ,fst_guar_comp_pric_fubon number(30,2) -- 第一担保代偿本金_唯品富邦
    ,fst_guar_comp_int_fubon number(30,2) -- 第一担保代偿利息_唯品富邦
    ,fst_guar_comp_pnlt_fubon number(30,2) -- 第一担保代偿罚息_唯品富邦
    ,fst_guar_comp_comp_int_fubon number(30,2) -- 第一担保代偿复利_唯品富邦
    ,secd_guar_id varchar2(100) -- 第二担保编号
    ,secd_guar_ratio number(18,6) -- 第二担保比例
    ,secd_guar_comp_tot_invtor number(30,2) -- 第二担保代偿总额_资金方
    ,secd_guar_comp_pric_invtor number(30,2) -- 第二担保代偿本金_资金方
    ,secd_guar_comp_int_invtor number(30,2) -- 第二担保代偿利息_资金方
    ,secd_guar_comp_pnlt_invtor number(30,2) -- 第二担保代偿罚息_资金方
    ,secd_guar_comp_com_int_invtor number(30,2) -- 第二担保代偿复利_资金方
    ,secd_guar_comp_tot_fubon number(30,2) -- 第二担保代偿总额_唯品富邦
    ,secd_guar_comp_pric_fubon number(30,2) -- 第二担保代偿本金_唯品富邦
    ,secd_guar_comp_int_fubon number(30,2) -- 第二担保代偿利息_唯品富邦
    ,secd_guar_comp_pnlt_fubon number(30,2) -- 第二担保代偿罚息_唯品富邦
    ,secd_guar_comp_comp_int_fubon number(30,2) -- 第二担保代偿复利_唯品富邦
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
grant select on ${iml_schema}.evt_wph_comp_dtl to ${icl_schema};
grant select on ${iml_schema}.evt_wph_comp_dtl to ${idl_schema};
grant select on ${iml_schema}.evt_wph_comp_dtl to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_wph_comp_dtl is '唯品会代偿明细';
comment on column ${iml_schema}.evt_wph_comp_dtl.evt_id is '事件编号';
comment on column ${iml_schema}.evt_wph_comp_dtl.lp_id is '法人编号';
comment on column ${iml_schema}.evt_wph_comp_dtl.repay_flow_num is '还款流水号';
comment on column ${iml_schema}.evt_wph_comp_dtl.tran_dt is '交易日期';
comment on column ${iml_schema}.evt_wph_comp_dtl.dubil_id is '借据编号';
comment on column ${iml_schema}.evt_wph_comp_dtl.ths_tm_comp_perds is '本次代偿期数';
comment on column ${iml_schema}.evt_wph_comp_dtl.prod_id is '产品编号';
comment on column ${iml_schema}.evt_wph_comp_dtl.curr_cd is '币种代码';
comment on column ${iml_schema}.evt_wph_comp_dtl.fin_guar_mode_cd is '融担模式代码';
comment on column ${iml_schema}.evt_wph_comp_dtl.repaybl_dt is '应还款日期';
comment on column ${iml_schema}.evt_wph_comp_dtl.actl_repay_dt is '实际还款日期';
comment on column ${iml_schema}.evt_wph_comp_dtl.ovdue_days is '贷款逾期天数';
comment on column ${iml_schema}.evt_wph_comp_dtl.comp_dt is '代偿日期';
comment on column ${iml_schema}.evt_wph_comp_dtl.ths_tm_comp_tot_invtor is '本次代偿总额_资金方';
comment on column ${iml_schema}.evt_wph_comp_dtl.ths_tm_comp_pric_invtor is '本次代偿本金_资金方';
comment on column ${iml_schema}.evt_wph_comp_dtl.ths_tm_comp_int_invtor is '本次代偿利息_资金方';
comment on column ${iml_schema}.evt_wph_comp_dtl.ths_tm_comp_pnlt_invtor is '本次代偿罚息_资金方';
comment on column ${iml_schema}.evt_wph_comp_dtl.ths_tm_comp_comp_int_invtor is '本次代偿复利_资金方';
comment on column ${iml_schema}.evt_wph_comp_dtl.ths_tm_comp_tot_fubon is '本次代偿总额_唯品富邦';
comment on column ${iml_schema}.evt_wph_comp_dtl.ths_tm_comp_pric_fubon is '本次代偿本金_唯品富邦';
comment on column ${iml_schema}.evt_wph_comp_dtl.ths_tm_comp_int_fubon is '本次代偿利息_唯品富邦';
comment on column ${iml_schema}.evt_wph_comp_dtl.ths_tm_comp_pnlt_fubon is '本次代偿罚息_唯品富邦';
comment on column ${iml_schema}.evt_wph_comp_dtl.ths_tm_comp_comp_int_fubon is '本次代偿复利_唯品富邦';
comment on column ${iml_schema}.evt_wph_comp_dtl.fst_guar_id is '第一担保编号';
comment on column ${iml_schema}.evt_wph_comp_dtl.fst_guar_ratio is '第一担保比例';
comment on column ${iml_schema}.evt_wph_comp_dtl.fst_guar_comp_tot_invtor is '第一担保代偿总额_资金方';
comment on column ${iml_schema}.evt_wph_comp_dtl.fst_guar_comp_pric_invtor is '第一担保代偿本金_资金方';
comment on column ${iml_schema}.evt_wph_comp_dtl.fst_guar_comp_int_invtor is '第一担保代偿利息_资金方';
comment on column ${iml_schema}.evt_wph_comp_dtl.fst_guar_comp_pnlt_invtor is '第一担保代偿罚息_资金方';
comment on column ${iml_schema}.evt_wph_comp_dtl.fst_guar_comp_comp_int_invtor is '第一担保代偿复利_资金方';
comment on column ${iml_schema}.evt_wph_comp_dtl.fst_guar_comp_tot_fubon is '第一担保代偿总额_唯品富邦';
comment on column ${iml_schema}.evt_wph_comp_dtl.fst_guar_comp_pric_fubon is '第一担保代偿本金_唯品富邦';
comment on column ${iml_schema}.evt_wph_comp_dtl.fst_guar_comp_int_fubon is '第一担保代偿利息_唯品富邦';
comment on column ${iml_schema}.evt_wph_comp_dtl.fst_guar_comp_pnlt_fubon is '第一担保代偿罚息_唯品富邦';
comment on column ${iml_schema}.evt_wph_comp_dtl.fst_guar_comp_comp_int_fubon is '第一担保代偿复利_唯品富邦';
comment on column ${iml_schema}.evt_wph_comp_dtl.secd_guar_id is '第二担保编号';
comment on column ${iml_schema}.evt_wph_comp_dtl.secd_guar_ratio is '第二担保比例';
comment on column ${iml_schema}.evt_wph_comp_dtl.secd_guar_comp_tot_invtor is '第二担保代偿总额_资金方';
comment on column ${iml_schema}.evt_wph_comp_dtl.secd_guar_comp_pric_invtor is '第二担保代偿本金_资金方';
comment on column ${iml_schema}.evt_wph_comp_dtl.secd_guar_comp_int_invtor is '第二担保代偿利息_资金方';
comment on column ${iml_schema}.evt_wph_comp_dtl.secd_guar_comp_pnlt_invtor is '第二担保代偿罚息_资金方';
comment on column ${iml_schema}.evt_wph_comp_dtl.secd_guar_comp_com_int_invtor is '第二担保代偿复利_资金方';
comment on column ${iml_schema}.evt_wph_comp_dtl.secd_guar_comp_tot_fubon is '第二担保代偿总额_唯品富邦';
comment on column ${iml_schema}.evt_wph_comp_dtl.secd_guar_comp_pric_fubon is '第二担保代偿本金_唯品富邦';
comment on column ${iml_schema}.evt_wph_comp_dtl.secd_guar_comp_int_fubon is '第二担保代偿利息_唯品富邦';
comment on column ${iml_schema}.evt_wph_comp_dtl.secd_guar_comp_pnlt_fubon is '第二担保代偿罚息_唯品富邦';
comment on column ${iml_schema}.evt_wph_comp_dtl.secd_guar_comp_comp_int_fubon is '第二担保代偿复利_唯品富邦';
comment on column ${iml_schema}.evt_wph_comp_dtl.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.evt_wph_comp_dtl.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_wph_comp_dtl.job_cd is '任务编码';
comment on column ${iml_schema}.evt_wph_comp_dtl.etl_timestamp is 'ETL处理时间戳';
