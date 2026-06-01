/*
Purpose:    整全模型层-全量切片脚本，清空目标表当天分区数据，把源表当天数据全量数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_wyd_repay_plan_icmsf1
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
drop table ${iml_schema}.agt_wyd_repay_plan_icmsf1_tm purge;
alter table ${iml_schema}.agt_wyd_repay_plan add partition p_icmsf1 values ('icmsf1')(
        subpartition p_icmsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.agt_wyd_repay_plan modify partition p_icmsf1
    add subpartition p_icmsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_wyd_repay_plan_icmsf1_tm
compress ${option_switch} for query high
as
select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,dubil_id -- 借据编号
    ,perds -- 期数
    ,cust_id -- 客户编号
    ,prod_id -- 产品编号
    ,level5_cls_cd -- 五级分类代码
    ,exp_dt -- 到期日期
    ,value_dt -- 起息日期
    ,currt_rpbl_pric -- 当期应还本金
    ,currt_paid_pric -- 当期实还本金
    ,currt_rpbl_tot_int -- 当期应还总利息
    ,currt_paid_int -- 当期实还利息
    ,currt_aldy_payoff_flg -- 当期已结清标志
    ,currt_payoff_dt -- 当期结清日期
    ,ovdue_amt -- 逾期金额
    ,defer_dt -- 顺延日期
    ,rpbl_int -- 应还利息
    ,rpbl_pric_pnlt -- 应还本金罚息
    ,rpbl_int_pnlt -- 应还利息罚息
    ,paid_int -- 实还利息
    ,paid_pric_pnlt -- 实还本金罚息
    ,paid_int_pnlt -- 实还利息罚息
    ,pric_status_cd -- 本金状态代码
    ,derate_int -- 减免利息
    ,derate_pnlt -- 减免罚息
    ,pric_turn_ovdue_dt -- 本金转逾期日期
    ,int_turn_ovdue_dt -- 利息转逾期日期
    ,pric_ovdue_days -- 本金逾期天数
    ,int_ovdue_days -- 利息逾期天数
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_belong_org_id -- 登记所属机构编号
    ,rgst_dt -- 登记日期
    ,final_update_teller_id -- 最后更新柜员编号
    ,final_update_org_id -- 最后更新机构编号
    ,final_update_dt -- 最后更新日期
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_wyd_repay_plan
where 0=1;


-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
-- 3.1 insert data to tm table
-- icms_wyd_payment_sched-1
insert into ${iml_schema}.agt_wyd_repay_plan_icmsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,dubil_id -- 借据编号
    ,perds -- 期数
    ,cust_id -- 客户编号
    ,prod_id -- 产品编号
    ,level5_cls_cd -- 五级分类代码
    ,exp_dt -- 到期日期
    ,value_dt -- 起息日期
    ,currt_rpbl_pric -- 当期应还本金
    ,currt_paid_pric -- 当期实还本金
    ,currt_rpbl_tot_int -- 当期应还总利息
    ,currt_paid_int -- 当期实还利息
    ,currt_aldy_payoff_flg -- 当期已结清标志
    ,currt_payoff_dt -- 当期结清日期
    ,ovdue_amt -- 逾期金额
    ,defer_dt -- 顺延日期
    ,rpbl_int -- 应还利息
    ,rpbl_pric_pnlt -- 应还本金罚息
    ,rpbl_int_pnlt -- 应还利息罚息
    ,paid_int -- 实还利息
    ,paid_pric_pnlt -- 实还本金罚息
    ,paid_int_pnlt -- 实还利息罚息
    ,pric_status_cd -- 本金状态代码
    ,derate_int -- 减免利息
    ,derate_pnlt -- 减免罚息
    ,pric_turn_ovdue_dt -- 本金转逾期日期
    ,int_turn_ovdue_dt -- 利息转逾期日期
    ,pric_ovdue_days -- 本金逾期天数
    ,int_ovdue_days -- 利息逾期天数
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_belong_org_id -- 登记所属机构编号
    ,rgst_dt -- 登记日期
    ,final_update_teller_id -- 最后更新柜员编号
    ,final_update_org_id -- 最后更新机构编号
    ,final_update_dt -- 最后更新日期
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '300066'||P1.LENDINGREF||P1.TERM -- 协议编号
    ,'9999' -- 法人编号
    ,P1.LENDINGREF -- 借据编号
    ,to_number(nvl(trim(P1.TERM),0)) -- 期数
    ,P1.CUSTOMERID -- 客户编号
    ,P1.PRODUCTID -- 产品编号
    ,nvl(trim（P1.CLASSIFYRESULT),'99') -- 五级分类代码
    ,${iml_schema}.dateformat_max2(P1.PMATURITYDATE) -- 到期日期
    ,${iml_schema}.dateformat_max2(P1.dateOfValue) -- 起息日期
    ,P1.PREPAY -- 当期应还本金
    ,P1.PREPAYACT -- 当期实还本金
    ,P1.IREPAY -- 当期应还总利息
    ,P1.IREPAYACT -- 当期实还利息
    ,decode(P1.DSTATUS,' ','-','Y','1','N','0',P1.DSTATUS) -- 当期已结清标志
    ,${iml_schema}.dateformat_max2(P1.FINISHDATE) -- 当期结清日期
    ,P1.POVERDUEAMT -- 逾期金额
    ,${iml_schema}.dateformat_max2(P1.INTEDATE) -- 顺延日期
    ,P1.PAYINTERESTAMT -- 应还利息
    ,P1.PAYPRINCIPALPENALTYAMT -- 应还本金罚息
    ,P1.PAYINTERESTPENALTYAMT -- 应还利息罚息
    ,P1.ACTUALPAYINTERESTAMT -- 实还利息
    ,P1.ACTUALPAYPRINCIPALPENALTYAMT -- 实还本金罚息
    ,P1.ACTUALPAYINTERESTPENALTYAMT -- 实还利息罚息
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'|| P1.PSTATUS END -- 本金状态代码
    ,P1.WAIVEINTERESTAMT -- 减免利息
    ,P1.WAIVEPENALTYAMT -- 减免罚息
    ,${iml_schema}.dateformat_max2(P1.prinOvdDate) -- 本金转逾期日期
    ,${iml_schema}.dateformat_max2(P1.intOvdDate) -- 利息转逾期日期
    ,to_number(nvl(trim(P1.CAPITALOVERDAYS),0)) -- 本金逾期天数
    ,to_number(nvl(trim(P1.INTOVDDAYS),0)) -- 利息逾期天数
    ,P1.INPUTUSERID -- 登记柜员编号
    ,P1.INPUTORGID -- 登记所属机构编号
    ,P1.INPUTDATE -- 登记日期
    ,P1.UPDATEUSERID -- 最后更新柜员编号
    ,P1.UPDATEORGID -- 最后更新机构编号
    ,P1.UPDATEDATE -- 最后更新日期
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'icms_wyd_payment_sched' -- 源表名称
    ,'icmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.icms_wyd_payment_sched p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.PSTATUS = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'ICMS'
        AND R1.SRC_TAB_EN_NAME= 'ICMS_WYD_PAYMENT_SCHED'
        AND R1.SRC_FIELD_EN_NAME= 'PSTATUS'
        AND R1.TARGET_TAB_EN_NAME= 'AGT_WYD_REPAY_PLAN'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'PRIC_STATUS_CD'
where  1 = 1 
    and p1.etl_dt=to_date('${batch_date}','yyyymmdd')
;
commit;



-- 3.2 truncate target table batch_date partition
alter table ${iml_schema}.agt_wyd_repay_plan truncate subpartition p_icmsf1_${batch_date} reuse storage;


-- 3.3 exchage tm table and target table
alter table ${iml_schema}.agt_wyd_repay_plan exchange subpartition p_icmsf1_${batch_date} with table ${iml_schema}.agt_wyd_repay_plan_icmsf1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_wyd_repay_plan to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.agt_wyd_repay_plan_icmsf1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_wyd_repay_plan', partname => 'p_icmsf1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);