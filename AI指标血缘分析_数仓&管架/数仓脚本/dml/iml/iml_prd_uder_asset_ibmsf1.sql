/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_prd_uder_asset_ibmsf1
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 2.1 create backup table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
alter table ${iml_schema}.prd_uder_asset add partition p_ibmsf1 values ('ibmsf1')(
        subpartition p_ibmsf1_19000101 values less than (to_date('20991231','yyyymmdd'))
        ,subpartition p_ibmsf1_20991231 values less than (maxvalue)
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.prd_uder_asset_ibmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.prd_uder_asset partition for ('ibmsf1')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.prd_uder_asset_ibmsf1_tm purge;
drop table ${iml_schema}.prd_uder_asset_ibmsf1_op purge;
drop table ${iml_schema}.prd_uder_asset_ibmsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.prd_uder_asset_ibmsf1_tm nologging
compress ${option_switch} for query high
as select
    intnal_asset_id -- 内部资产编号
    ,lp_id -- 法人编号
    ,up_level_asset_id -- 上层资产编号
    ,fin_instm_id -- 金融工具编号
    ,asset_type_id -- 资产类型编号
    ,market_type_id -- 市场类型编号
    ,asset_id -- 资产编号
    ,asset_name -- 资产名称
    ,asset_cls_cd -- 资产分类代码
    ,asset_subdv_cd -- 资产细分类代码
    ,invest_amt -- 投资金额
    ,invest_dt -- 投资日期
    ,value_dt -- 起息日期
    ,exp_dt -- 到期日期
    ,int_rat -- 利率
    ,pay_int_freq -- 付息频率
    ,fir_pay_int_dt -- 首次付息日期
    ,curr_cd -- 币种代码
    ,imp_dt -- 导入日期
    ,cntpty_id -- 交易对手编号
    ,uder_asset_status_cd -- 底层资产状态代码
    ,ocup_crdt_flg -- 占用授信标志
    ,crdt_status_cd -- 授信状态代码
    ,crdt_main_id -- 授信主体编号
    ,crdt_wt -- 授信权重
    ,crdt_amt -- 授信金额
    ,checker_id -- 复核人编号
    ,check_tm -- 复核时间
    ,check_dt -- 复核日期
    ,invest_ratio -- 投资比例
    ,risk_wt -- 风险权重
    ,rating_rest_cd -- 评级结果代码
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.prd_uder_asset partition for ('ibmsf1')
where 0=1
;

create table ${iml_schema}.prd_uder_asset_ibmsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.prd_uder_asset partition for ('ibmsf1') where 0=1;

create table ${iml_schema}.prd_uder_asset_ibmsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.prd_uder_asset partition for ('ibmsf1') where 0=1;

-- 3.1 get new data into table
-- ibms_ttrd_und_asset-
insert into ${iml_schema}.prd_uder_asset_ibmsf1_tm(
    intnal_asset_id -- 内部资产编号
    ,lp_id -- 法人编号
    ,up_level_asset_id -- 上层资产编号
    ,fin_instm_id -- 金融工具编号
    ,asset_type_id -- 资产类型编号
    ,market_type_id -- 市场类型编号
    ,asset_id -- 资产编号
    ,asset_name -- 资产名称
    ,asset_cls_cd -- 资产分类代码
    ,asset_subdv_cd -- 资产细分类代码
    ,invest_amt -- 投资金额
    ,invest_dt -- 投资日期
    ,value_dt -- 起息日期
    ,exp_dt -- 到期日期
    ,int_rat -- 利率
    ,pay_int_freq -- 付息频率
    ,fir_pay_int_dt -- 首次付息日期
    ,curr_cd -- 币种代码
    ,imp_dt -- 导入日期
    ,cntpty_id -- 交易对手编号
    ,uder_asset_status_cd -- 底层资产状态代码
    ,ocup_crdt_flg -- 占用授信标志
    ,crdt_status_cd -- 授信状态代码
    ,crdt_main_id -- 授信主体编号
    ,crdt_wt -- 授信权重
    ,crdt_amt -- 授信金额
    ,checker_id -- 复核人编号
    ,check_tm -- 复核时间
    ,check_dt -- 复核日期
    ,invest_ratio -- 投资比例
    ,risk_wt -- 风险权重
    ,rating_rest_cd -- 评级结果代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.ID -- 内部资产编号
    ,'9999' -- 法人编号
    ,P1.PARENT_ID -- 上层资产编号
    ,P1.I_CODE -- 金融工具编号
    ,P1.A_TYPE -- 资产类型编号
    ,P1.M_TYPE -- 市场类型编号
    ,P1.U_I_CODE -- 资产编号
    ,P1.U_I_NAME -- 资产名称
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.A_CLASS END -- 资产分类代码
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||P1.A_CLASS_MIN END -- 资产细分类代码
    ,P1.AMOUNT -- 投资金额
    ,${iml_schema}.DATEFORMAT_MIN(P1.INV_DATE) -- 投资日期
    ,${iml_schema}.DATEFORMAT_MIN(P1.START_DATE) -- 起息日期
    ,${iml_schema}.DATEFORMAT_MAX(P1.MTR_DATE) -- 到期日期
    ,P1.COUPON*100 -- 利率
    ,P1.PAYMENT_FREQ -- 付息频率
    ,${iml_schema}.DATEFORMAT_MIN(P1.FIRST_PAYMENT_DATE) -- 首次付息日期
    ,NVL(TRIM(P1.CURRENCY),'CNY') -- 币种代码
    ,${iml_schema}.DATEFORMAT_MIN(P1.IMP_DATE) -- 导入日期
    ,TO_CHAR(P1.PARTY_ID) -- 交易对手编号
    ,NVL(TRIM(P1.UND_STATUS),'9') -- 底层资产状态代码
    ,NVL(TRIM(P1.IS_USING_CREDIT),'-') -- 占用授信标志
    ,CASE WHEN R3.TARGET_CD_VAL IS NOT NULL THEN R3.TARGET_CD_VAL ELSE '@'||P1.CREDIT_STATUS END -- 授信状态代码
    ,TO_CHAR(P1.CREDIT_PARTY_ID) -- 授信主体编号
    ,P1.CREDIT_WEIGHT -- 授信权重
    ,P1.CREDIT_AMOUNT -- 授信金额
    ,P1.ACCOUNT_USER -- 复核人编号
    ,${iml_schema}.DATEFORMAT_MAX(P1.ACCOUNT_TIME) -- 复核时间
    ,${iml_schema}.DATEFORMAT_MAX(P1.ACCOUNT_DATE) -- 复核日期
    ,P1.PROP -- 投资比例
    ,P1.RISK_WEIGHT -- 风险权重
    ,NVL(TRIM(P1.GRADE),'-') -- 评级结果代码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ibms_ttrd_und_asset' -- 源表名称
    ,'ibmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ibms_ttrd_und_asset p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.A_CLASS= R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'IBMS'
        AND R1.SRC_TAB_EN_NAME= 'IBMS_TTRD_UND_ASSET'
        AND R1.SRC_FIELD_EN_NAME= 'A_CLASS'
        AND R1.TARGET_TAB_EN_NAME= 'PRD_UDER_ASSET'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'ASSET_CLS_CD'
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.A_CLASS_MIN= R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'IBMS'
        AND R2.SRC_TAB_EN_NAME= 'IBMS_TTRD_UND_ASSET'
        AND R2.SRC_FIELD_EN_NAME= 'A_CLASS_MIN'
        AND R2.TARGET_TAB_EN_NAME= 'PRD_UDER_ASSET'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'ASSET_SUBDV_CD'
    left join ${iml_schema}.ref_pub_cd_map r3 on P1.CREDIT_STATUS= R3.SRC_CODE_VAL
        AND R3.SORC_SYS_CD= 'IBMS'
        AND R3.SRC_TAB_EN_NAME= 'IBMS_TTRD_UND_ASSET'
        AND R3.SRC_FIELD_EN_NAME= 'CREDIT_STATUS'
        AND R3.TARGET_TAB_EN_NAME= 'PRD_UDER_ASSET'
        AND R3.TARGET_TAB_FIELD_EN_NAME= 'CRDT_STATUS_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.prd_uder_asset_ibmsf1_tm 
  	                                group by 
  	                                        intnal_asset_id
  	                                        ,lp_id
  	                               having count(1) > 1);
    if cnt = 0 
      then
        continue;
      else
        raise_application_error(-20001,'primary key is duplication');
    end if;
  end loop;
end;
/


-- 3.2 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.prd_uder_asset_ibmsf1_cl(
            intnal_asset_id -- 内部资产编号
    ,lp_id -- 法人编号
    ,up_level_asset_id -- 上层资产编号
    ,fin_instm_id -- 金融工具编号
    ,asset_type_id -- 资产类型编号
    ,market_type_id -- 市场类型编号
    ,asset_id -- 资产编号
    ,asset_name -- 资产名称
    ,asset_cls_cd -- 资产分类代码
    ,asset_subdv_cd -- 资产细分类代码
    ,invest_amt -- 投资金额
    ,invest_dt -- 投资日期
    ,value_dt -- 起息日期
    ,exp_dt -- 到期日期
    ,int_rat -- 利率
    ,pay_int_freq -- 付息频率
    ,fir_pay_int_dt -- 首次付息日期
    ,curr_cd -- 币种代码
    ,imp_dt -- 导入日期
    ,cntpty_id -- 交易对手编号
    ,uder_asset_status_cd -- 底层资产状态代码
    ,ocup_crdt_flg -- 占用授信标志
    ,crdt_status_cd -- 授信状态代码
    ,crdt_main_id -- 授信主体编号
    ,crdt_wt -- 授信权重
    ,crdt_amt -- 授信金额
    ,checker_id -- 复核人编号
    ,check_tm -- 复核时间
    ,check_dt -- 复核日期
    ,invest_ratio -- 投资比例
    ,risk_wt -- 风险权重
    ,rating_rest_cd -- 评级结果代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.prd_uder_asset_ibmsf1_op(
            intnal_asset_id -- 内部资产编号
    ,lp_id -- 法人编号
    ,up_level_asset_id -- 上层资产编号
    ,fin_instm_id -- 金融工具编号
    ,asset_type_id -- 资产类型编号
    ,market_type_id -- 市场类型编号
    ,asset_id -- 资产编号
    ,asset_name -- 资产名称
    ,asset_cls_cd -- 资产分类代码
    ,asset_subdv_cd -- 资产细分类代码
    ,invest_amt -- 投资金额
    ,invest_dt -- 投资日期
    ,value_dt -- 起息日期
    ,exp_dt -- 到期日期
    ,int_rat -- 利率
    ,pay_int_freq -- 付息频率
    ,fir_pay_int_dt -- 首次付息日期
    ,curr_cd -- 币种代码
    ,imp_dt -- 导入日期
    ,cntpty_id -- 交易对手编号
    ,uder_asset_status_cd -- 底层资产状态代码
    ,ocup_crdt_flg -- 占用授信标志
    ,crdt_status_cd -- 授信状态代码
    ,crdt_main_id -- 授信主体编号
    ,crdt_wt -- 授信权重
    ,crdt_amt -- 授信金额
    ,checker_id -- 复核人编号
    ,check_tm -- 复核时间
    ,check_dt -- 复核日期
    ,invest_ratio -- 投资比例
    ,risk_wt -- 风险权重
    ,rating_rest_cd -- 评级结果代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.intnal_asset_id, o.intnal_asset_id) as intnal_asset_id -- 内部资产编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.up_level_asset_id, o.up_level_asset_id) as up_level_asset_id -- 上层资产编号
    ,nvl(n.fin_instm_id, o.fin_instm_id) as fin_instm_id -- 金融工具编号
    ,nvl(n.asset_type_id, o.asset_type_id) as asset_type_id -- 资产类型编号
    ,nvl(n.market_type_id, o.market_type_id) as market_type_id -- 市场类型编号
    ,nvl(n.asset_id, o.asset_id) as asset_id -- 资产编号
    ,nvl(n.asset_name, o.asset_name) as asset_name -- 资产名称
    ,nvl(n.asset_cls_cd, o.asset_cls_cd) as asset_cls_cd -- 资产分类代码
    ,nvl(n.asset_subdv_cd, o.asset_subdv_cd) as asset_subdv_cd -- 资产细分类代码
    ,nvl(n.invest_amt, o.invest_amt) as invest_amt -- 投资金额
    ,nvl(n.invest_dt, o.invest_dt) as invest_dt -- 投资日期
    ,nvl(n.value_dt, o.value_dt) as value_dt -- 起息日期
    ,nvl(n.exp_dt, o.exp_dt) as exp_dt -- 到期日期
    ,nvl(n.int_rat, o.int_rat) as int_rat -- 利率
    ,nvl(n.pay_int_freq, o.pay_int_freq) as pay_int_freq -- 付息频率
    ,nvl(n.fir_pay_int_dt, o.fir_pay_int_dt) as fir_pay_int_dt -- 首次付息日期
    ,nvl(n.curr_cd, o.curr_cd) as curr_cd -- 币种代码
    ,nvl(n.imp_dt, o.imp_dt) as imp_dt -- 导入日期
    ,nvl(n.cntpty_id, o.cntpty_id) as cntpty_id -- 交易对手编号
    ,nvl(n.uder_asset_status_cd, o.uder_asset_status_cd) as uder_asset_status_cd -- 底层资产状态代码
    ,nvl(n.ocup_crdt_flg, o.ocup_crdt_flg) as ocup_crdt_flg -- 占用授信标志
    ,nvl(n.crdt_status_cd, o.crdt_status_cd) as crdt_status_cd -- 授信状态代码
    ,nvl(n.crdt_main_id, o.crdt_main_id) as crdt_main_id -- 授信主体编号
    ,nvl(n.crdt_wt, o.crdt_wt) as crdt_wt -- 授信权重
    ,nvl(n.crdt_amt, o.crdt_amt) as crdt_amt -- 授信金额
    ,nvl(n.checker_id, o.checker_id) as checker_id -- 复核人编号
    ,nvl(n.check_tm, o.check_tm) as check_tm -- 复核时间
    ,nvl(n.check_dt, o.check_dt) as check_dt -- 复核日期
    ,nvl(n.invest_ratio, o.invest_ratio) as invest_ratio -- 投资比例
    ,nvl(n.risk_wt, o.risk_wt) as risk_wt -- 风险权重
    ,nvl(n.rating_rest_cd, o.rating_rest_cd) as rating_rest_cd -- 评级结果代码
    ,case when
            n.intnal_asset_id is null
            and n.lp_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.intnal_asset_id is null
            and n.lp_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.intnal_asset_id is null
            and n.lp_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.prd_uder_asset_ibmsf1_tm n
    full join (select * from ${iml_schema}.prd_uder_asset_ibmsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.intnal_asset_id = n.intnal_asset_id
            and o.lp_id = n.lp_id
where (
        o.intnal_asset_id is null
        and o.lp_id is null
    )
    or (
        n.intnal_asset_id is null
        and n.lp_id is null
    )
    or (
        o.up_level_asset_id <> n.up_level_asset_id
        or o.fin_instm_id <> n.fin_instm_id
        or o.asset_type_id <> n.asset_type_id
        or o.market_type_id <> n.market_type_id
        or o.asset_id <> n.asset_id
        or o.asset_name <> n.asset_name
        or o.asset_cls_cd <> n.asset_cls_cd
        or o.asset_subdv_cd <> n.asset_subdv_cd
        or o.invest_amt <> n.invest_amt
        or o.invest_dt <> n.invest_dt
        or o.value_dt <> n.value_dt
        or o.exp_dt <> n.exp_dt
        or o.int_rat <> n.int_rat
        or o.pay_int_freq <> n.pay_int_freq
        or o.fir_pay_int_dt <> n.fir_pay_int_dt
        or o.curr_cd <> n.curr_cd
        or o.imp_dt <> n.imp_dt
        or o.cntpty_id <> n.cntpty_id
        or o.uder_asset_status_cd <> n.uder_asset_status_cd
        or o.ocup_crdt_flg <> n.ocup_crdt_flg
        or o.crdt_status_cd <> n.crdt_status_cd
        or o.crdt_main_id <> n.crdt_main_id
        or o.crdt_wt <> n.crdt_wt
        or o.crdt_amt <> n.crdt_amt
        or o.checker_id <> n.checker_id
        or o.check_tm <> n.check_tm
        or o.check_dt <> n.check_dt
        or o.invest_ratio <> n.invest_ratio
        or o.risk_wt <> n.risk_wt
        or o.rating_rest_cd <> n.rating_rest_cd
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.prd_uder_asset_ibmsf1_cl(
            intnal_asset_id -- 内部资产编号
    ,lp_id -- 法人编号
    ,up_level_asset_id -- 上层资产编号
    ,fin_instm_id -- 金融工具编号
    ,asset_type_id -- 资产类型编号
    ,market_type_id -- 市场类型编号
    ,asset_id -- 资产编号
    ,asset_name -- 资产名称
    ,asset_cls_cd -- 资产分类代码
    ,asset_subdv_cd -- 资产细分类代码
    ,invest_amt -- 投资金额
    ,invest_dt -- 投资日期
    ,value_dt -- 起息日期
    ,exp_dt -- 到期日期
    ,int_rat -- 利率
    ,pay_int_freq -- 付息频率
    ,fir_pay_int_dt -- 首次付息日期
    ,curr_cd -- 币种代码
    ,imp_dt -- 导入日期
    ,cntpty_id -- 交易对手编号
    ,uder_asset_status_cd -- 底层资产状态代码
    ,ocup_crdt_flg -- 占用授信标志
    ,crdt_status_cd -- 授信状态代码
    ,crdt_main_id -- 授信主体编号
    ,crdt_wt -- 授信权重
    ,crdt_amt -- 授信金额
    ,checker_id -- 复核人编号
    ,check_tm -- 复核时间
    ,check_dt -- 复核日期
    ,invest_ratio -- 投资比例
    ,risk_wt -- 风险权重
    ,rating_rest_cd -- 评级结果代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.prd_uder_asset_ibmsf1_op(
            intnal_asset_id -- 内部资产编号
    ,lp_id -- 法人编号
    ,up_level_asset_id -- 上层资产编号
    ,fin_instm_id -- 金融工具编号
    ,asset_type_id -- 资产类型编号
    ,market_type_id -- 市场类型编号
    ,asset_id -- 资产编号
    ,asset_name -- 资产名称
    ,asset_cls_cd -- 资产分类代码
    ,asset_subdv_cd -- 资产细分类代码
    ,invest_amt -- 投资金额
    ,invest_dt -- 投资日期
    ,value_dt -- 起息日期
    ,exp_dt -- 到期日期
    ,int_rat -- 利率
    ,pay_int_freq -- 付息频率
    ,fir_pay_int_dt -- 首次付息日期
    ,curr_cd -- 币种代码
    ,imp_dt -- 导入日期
    ,cntpty_id -- 交易对手编号
    ,uder_asset_status_cd -- 底层资产状态代码
    ,ocup_crdt_flg -- 占用授信标志
    ,crdt_status_cd -- 授信状态代码
    ,crdt_main_id -- 授信主体编号
    ,crdt_wt -- 授信权重
    ,crdt_amt -- 授信金额
    ,checker_id -- 复核人编号
    ,check_tm -- 复核时间
    ,check_dt -- 复核日期
    ,invest_ratio -- 投资比例
    ,risk_wt -- 风险权重
    ,rating_rest_cd -- 评级结果代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.intnal_asset_id -- 内部资产编号
    ,o.lp_id -- 法人编号
    ,o.up_level_asset_id -- 上层资产编号
    ,o.fin_instm_id -- 金融工具编号
    ,o.asset_type_id -- 资产类型编号
    ,o.market_type_id -- 市场类型编号
    ,o.asset_id -- 资产编号
    ,o.asset_name -- 资产名称
    ,o.asset_cls_cd -- 资产分类代码
    ,o.asset_subdv_cd -- 资产细分类代码
    ,o.invest_amt -- 投资金额
    ,o.invest_dt -- 投资日期
    ,o.value_dt -- 起息日期
    ,o.exp_dt -- 到期日期
    ,o.int_rat -- 利率
    ,o.pay_int_freq -- 付息频率
    ,o.fir_pay_int_dt -- 首次付息日期
    ,o.curr_cd -- 币种代码
    ,o.imp_dt -- 导入日期
    ,o.cntpty_id -- 交易对手编号
    ,o.uder_asset_status_cd -- 底层资产状态代码
    ,o.ocup_crdt_flg -- 占用授信标志
    ,o.crdt_status_cd -- 授信状态代码
    ,o.crdt_main_id -- 授信主体编号
    ,o.crdt_wt -- 授信权重
    ,o.crdt_amt -- 授信金额
    ,o.checker_id -- 复核人编号
    ,o.check_tm -- 复核时间
    ,o.check_dt -- 复核日期
    ,o.invest_ratio -- 投资比例
    ,o.risk_wt -- 风险权重
    ,o.rating_rest_cd -- 评级结果代码
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,o.src_table_name -- 源表名称
    ,o.job_cd -- 任务编码
    ,o.etl_timestamp -- ETL处理时间戳
from ${iml_schema}.prd_uder_asset_ibmsf1_bk o
    left join ${iml_schema}.prd_uder_asset_ibmsf1_op n
        on
            o.intnal_asset_id = n.intnal_asset_id
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.prd_uder_asset_ibmsf1_cl d
        on
            o.intnal_asset_id = d.intnal_asset_id
            and o.lp_id = d.lp_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iml_schema}.prd_uder_asset;
alter table ${iml_schema}.prd_uder_asset truncate partition for ('ibmsf1') reuse storage;

-- 4.2 exchange partition
alter table ${iml_schema}.prd_uder_asset exchange subpartition p_ibmsf1_19000101 with table ${iml_schema}.prd_uder_asset_ibmsf1_cl;
alter table ${iml_schema}.prd_uder_asset exchange subpartition p_ibmsf1_20991231 with table ${iml_schema}.prd_uder_asset_ibmsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.prd_uder_asset to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.prd_uder_asset_ibmsf1_tm purge;
drop table ${iml_schema}.prd_uder_asset_ibmsf1_op purge;
drop table ${iml_schema}.prd_uder_asset_ibmsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.prd_uder_asset_ibmsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'prd_uder_asset', partname => 'p_ibmsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
