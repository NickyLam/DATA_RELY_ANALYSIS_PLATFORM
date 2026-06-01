/*
Purpose:    整全模型层-增量流水脚本，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_wph_comp_dtl_icmsi1
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 2.1 create table for exchage and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.evt_wph_comp_dtl_icmsi1_tm purge;
alter table ${iml_schema}.evt_wph_comp_dtl add partition p_icmsi1 values ('icmsi1')(
        subpartition p_icmsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_wph_comp_dtl modify partition p_icmsi1
    add subpartition p_icmsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_wph_comp_dtl_icmsi1_tm
compress ${option_switch} for query high
as
select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,repay_flow_num -- 还款流水号
    ,tran_dt -- 交易日期
    ,dubil_id -- 借据编号
    ,ths_tm_comp_perds -- 本次代偿期数
    ,prod_id -- 产品编号
    ,curr_cd -- 币种代码
    ,fin_guar_mode_cd -- 融担模式代码
    ,repaybl_dt -- 应还款日期
    ,actl_repay_dt -- 实际还款日期
    ,ovdue_days -- 贷款逾期天数
    ,comp_dt -- 代偿日期
    ,ths_tm_comp_tot_invtor -- 本次代偿总额_资金方
    ,ths_tm_comp_pric_invtor -- 本次代偿本金_资金方
    ,ths_tm_comp_int_invtor -- 本次代偿利息_资金方
    ,ths_tm_comp_pnlt_invtor -- 本次代偿罚息_资金方
    ,ths_tm_comp_comp_int_invtor -- 本次代偿复利_资金方
    ,ths_tm_comp_tot_fubon -- 本次代偿总额_唯品富邦
    ,ths_tm_comp_pric_fubon -- 本次代偿本金_唯品富邦
    ,ths_tm_comp_int_fubon -- 本次代偿利息_唯品富邦
    ,ths_tm_comp_pnlt_fubon -- 本次代偿罚息_唯品富邦
    ,ths_tm_comp_comp_int_fubon -- 本次代偿复利_唯品富邦
    ,fst_guar_id -- 第一担保编号
    ,fst_guar_ratio -- 第一担保比例
    ,fst_guar_comp_tot_invtor -- 第一担保代偿总额_资金方
    ,fst_guar_comp_pric_invtor -- 第一担保代偿本金_资金方
    ,fst_guar_comp_int_invtor -- 第一担保代偿利息_资金方
    ,fst_guar_comp_pnlt_invtor -- 第一担保代偿罚息_资金方
    ,fst_guar_comp_comp_int_invtor -- 第一担保代偿复利_资金方
    ,fst_guar_comp_tot_fubon -- 第一担保代偿总额_唯品富邦
    ,fst_guar_comp_pric_fubon -- 第一担保代偿本金_唯品富邦
    ,fst_guar_comp_int_fubon -- 第一担保代偿利息_唯品富邦
    ,fst_guar_comp_pnlt_fubon -- 第一担保代偿罚息_唯品富邦
    ,fst_guar_comp_comp_int_fubon -- 第一担保代偿复利_唯品富邦
    ,secd_guar_id -- 第二担保编号
    ,secd_guar_ratio -- 第二担保比例
    ,secd_guar_comp_tot_invtor -- 第二担保代偿总额_资金方
    ,secd_guar_comp_pric_invtor -- 第二担保代偿本金_资金方
    ,secd_guar_comp_int_invtor -- 第二担保代偿利息_资金方
    ,secd_guar_comp_pnlt_invtor -- 第二担保代偿罚息_资金方
    ,secd_guar_comp_com_int_invtor -- 第二担保代偿复利_资金方
    ,secd_guar_comp_tot_fubon -- 第二担保代偿总额_唯品富邦
    ,secd_guar_comp_pric_fubon -- 第二担保代偿本金_唯品富邦
    ,secd_guar_comp_int_fubon -- 第二担保代偿利息_唯品富邦
    ,secd_guar_comp_pnlt_fubon -- 第二担保代偿罚息_唯品富邦
    ,secd_guar_comp_comp_int_fubon -- 第二担保代偿复利_唯品富邦
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_wph_comp_dtl
where 0=1;


-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
-- 3.1 insert data to tm table
-- icms_wph_compensation_detail-1
insert into ${iml_schema}.evt_wph_comp_dtl_icmsi1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,repay_flow_num -- 还款流水号
    ,tran_dt -- 交易日期
    ,dubil_id -- 借据编号
    ,prod_id -- 本次代偿期数
    ,curr_cd -- 产品编号
    ,ths_tm_comp_perds -- 币种代码
    ,fin_guar_mode_cd -- 融担模式代码
    ,repaybl_dt -- 应还款日期
    ,actl_repay_dt -- 实际还款日期
    ,ovdue_days -- 贷款逾期天数
    ,comp_dt -- 代偿日期
    ,ths_tm_comp_tot_invtor -- 本次代偿总额_资金方
    ,ths_tm_comp_pric_invtor -- 本次代偿本金_资金方
    ,ths_tm_comp_int_invtor -- 本次代偿利息_资金方
    ,ths_tm_comp_pnlt_invtor -- 本次代偿罚息_资金方
    ,ths_tm_comp_comp_int_invtor -- 本次代偿复利_资金方
    ,ths_tm_comp_tot_fubon -- 本次代偿总额_唯品富邦
    ,ths_tm_comp_pric_fubon -- 本次代偿本金_唯品富邦
    ,ths_tm_comp_int_fubon -- 本次代偿利息_唯品富邦
    ,ths_tm_comp_pnlt_fubon -- 本次代偿罚息_唯品富邦
    ,ths_tm_comp_comp_int_fubon -- 本次代偿复利_唯品富邦
    ,fst_guar_id -- 第一担保编号
    ,fst_guar_ratio -- 第一担保比例
    ,fst_guar_comp_tot_invtor -- 第一担保代偿总额_资金方
    ,fst_guar_comp_pric_invtor -- 第一担保代偿本金_资金方
    ,fst_guar_comp_int_invtor -- 第一担保代偿利息_资金方
    ,fst_guar_comp_pnlt_invtor -- 第一担保代偿罚息_资金方
    ,fst_guar_comp_comp_int_invtor -- 第一担保代偿复利_资金方
    ,fst_guar_comp_tot_fubon -- 第一担保代偿总额_唯品富邦
    ,fst_guar_comp_pric_fubon -- 第一担保代偿本金_唯品富邦
    ,fst_guar_comp_int_fubon -- 第一担保代偿利息_唯品富邦
    ,fst_guar_comp_pnlt_fubon -- 第一担保代偿罚息_唯品富邦
    ,fst_guar_comp_comp_int_fubon -- 第一担保代偿复利_唯品富邦
    ,secd_guar_id -- 第二担保编号
    ,secd_guar_ratio -- 第二担保比例
    ,secd_guar_comp_tot_invtor -- 第二担保代偿总额_资金方
    ,secd_guar_comp_pric_invtor -- 第二担保代偿本金_资金方
    ,secd_guar_comp_int_invtor -- 第二担保代偿利息_资金方
    ,secd_guar_comp_pnlt_invtor -- 第二担保代偿罚息_资金方
    ,secd_guar_comp_com_int_invtor -- 第二担保代偿复利_资金方
    ,secd_guar_comp_tot_fubon -- 第二担保代偿总额_唯品富邦
    ,secd_guar_comp_pric_fubon -- 第二担保代偿本金_唯品富邦
    ,secd_guar_comp_int_fubon -- 第二担保代偿利息_唯品富邦
    ,secd_guar_comp_pnlt_fubon -- 第二担保代偿罚息_唯品富邦
    ,secd_guar_comp_comp_int_fubon -- 第二担保代偿复利_唯品富邦
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '401051'||P1.RECEIPTNO -- 事件编号
    ,'9999' -- 法人编号
    ,P1.RECEIPTNO -- 还款流水号
    ,${iml_schema}.dateformat_max2(P1.TRANDATE) -- 交易日期
    ,P1.INTERNALKEY -- 借据编号
    ,P1.PRODTYPE -- 本次代偿期数
    ,P1.CCY -- 产品编号
    ,to_number(nvl(trim(P1.COMPSTAGENO),'0')) -- 币种代码
    ,P1.UNIONGUARANTEEFLAG -- 融担模式代码
    ,${iml_schema}.dateformat_max2(P1.PAYDATE) -- 应还款日期
    ,${iml_schema}.dateformat_max2(P1.ACTREPAYDATE) -- 实际还款日期
    ,P1.OVEDATE -- 贷款逾期天数
    ,${iml_schema}.dateformat_max2(P1.COMPDATE) -- 代偿日期
    ,P1.COMPAMTPARTNER -- 本次代偿总额_资金方
    ,P1.COMPPRIAMTPARTNER -- 本次代偿本金_资金方
    ,P1.COMPINTAMTPARTNER -- 本次代偿利息_资金方
    ,P1.COMPODPAMTPARTNER -- 本次代偿罚息_资金方
    ,P1.COMPODIAMTPARTNER -- 本次代偿复利_资金方
    ,P1.COMPAMTWPFB -- 本次代偿总额_唯品富邦
    ,P1.COMPPRIAMTWPFB -- 本次代偿本金_唯品富邦
    ,P1.COMPINTAMTWPFB -- 本次代偿利息_唯品富邦
    ,P1.COMPODPAMTWPFB -- 本次代偿罚息_唯品富邦
    ,P1.COMPODIAMTWPFB -- 本次代偿复利_唯品富邦
    ,P1.GUARANTEEAID -- 第一担保编号
    ,P1.GUARANTEEARATE -- 第一担保比例
    ,P1.GUARANTEEAAMTPARTNER -- 第一担保代偿总额_资金方
    ,P1.GUARANTEEAPRIAMTPARTNER -- 第一担保代偿本金_资金方
    ,P1.GUARANTEEAINTAMTPARTNER -- 第一担保代偿利息_资金方
    ,P1.GUARANTEEAODPAMTPARTNER -- 第一担保代偿罚息_资金方
    ,P1.GUARANTEEAODIAMTPARTNER -- 第一担保代偿复利_资金方
    ,P1.GUARANTEEAAMTWPFB -- 第一担保代偿总额_唯品富邦
    ,P1.GUARANTEEAPRIAMTWPFB -- 第一担保代偿本金_唯品富邦
    ,P1.GUARANTEEAINTAMTWPFB -- 第一担保代偿利息_唯品富邦
    ,P1.GUARANTEEAODPAMTWPFB -- 第一担保代偿罚息_唯品富邦
    ,P1.GUARANTEEAODIAMTWPFB -- 第一担保代偿复利_唯品富邦
    ,P1.GUARANTEEBID -- 第二担保编号
    ,P1.GUARANTEEBRATE -- 第二担保比例
    ,P1.GUARANTEEBAMTPARTNER -- 第二担保代偿总额_资金方
    ,P1.GUARANTEEBPRIAMTPARTNER -- 第二担保代偿本金_资金方
    ,P1.GUARANTEEBINTAMTPARTNER -- 第二担保代偿利息_资金方
    ,P1.GUARANTEEBODPAMTPARTNER -- 第二担保代偿罚息_资金方
    ,P1.GUARANTEEBODIAMTPARTNER -- 第二担保代偿复利_资金方
    ,P1.GUARANTEEBAMTWPFB -- 第二担保代偿总额_唯品富邦
    ,P1.GUARANTEEBPRIAMTWPFB -- 第二担保代偿本金_唯品富邦
    ,P1.GUARANTEEBINTAMTWPFB -- 第二担保代偿利息_唯品富邦
    ,P1.GUARANTEEBODPAMTWPFB -- 第二担保代偿罚息_唯品富邦
    ,P1.GUARANTEEBODIAMTWPFB -- 第二担保代偿复利_唯品富邦
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'icms_wph_compensation_detail' -- 源表名称
    ,'icmsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.icms_wph_compensation_detail p1
where  1 = 1 
and p1.etl_dt = to_date('${batch_date}','yyyymmdd')
;
commit;



-- 3.2 truncate target table batch_date partition
alter table ${iml_schema}.evt_wph_comp_dtl truncate subpartition p_icmsi1_${batch_date} reuse storage;


-- 3.3 exchage tm table and target table
alter table ${iml_schema}.evt_wph_comp_dtl exchange subpartition p_icmsi1_${batch_date} with table ${iml_schema}.evt_wph_comp_dtl_icmsi1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_wph_comp_dtl to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.evt_wph_comp_dtl_icmsi1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_wph_comp_dtl', partname => 'p_icmsi1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);