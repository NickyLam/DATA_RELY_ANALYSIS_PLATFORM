/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_ast_lease_rent_asset_info_h_lmisf1
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
alter table ${iml_schema}.ast_lease_rent_asset_info_h add partition p_lmisf1 values ('lmisf1')(
        subpartition p_lmisf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_lmisf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.ast_lease_rent_asset_info_h_lmisf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.ast_lease_rent_asset_info_h partition for ('lmisf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.ast_lease_rent_asset_info_h_lmisf1_tm purge;
drop table ${iml_schema}.ast_lease_rent_asset_info_h_lmisf1_op purge;
drop table ${iml_schema}.ast_lease_rent_asset_info_h_lmisf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.ast_lease_rent_asset_info_h_lmisf1_tm nologging
compress ${option_switch} for query high
as select
    lease_asset_ser_num -- 承租资产序列号
    ,lp_id -- 法人编号
    ,asset_id -- 资产编号
    ,asset_ser_num -- 资产序列号
    ,lease_cont_ser_num -- 承租合同序列号
    ,cont_id -- 合同编号
    ,cont_name -- 合同名称
    ,cont_effect_dt -- 合同生效日期
    ,rent_ps_name -- 出租人名称
    ,acct_b_id -- 账簿编号
    ,asset_type_id -- 资产类型编号
    ,asset_name -- 资产名称
    ,asset_cate_ser_num -- 资产类别序列号
    ,asset_qtty -- 资产数量
    ,asset_status_cd -- 资产状态代码
    ,enter_acct_flg -- 入账标志
    ,rent_start_dt -- 租赁开始日期
    ,rent_exp_dt -- 租赁到期日期
    ,rent_tenor -- 租赁期限
    ,rent_tax_lmt -- 租赁税额
    ,plan_pay_pre_tax_tot -- 计划付款税前总额
    ,plan_pay_at_tot -- 计划付款税后总额
    ,year_disct_rat -- 年折现率
    ,day_disct_rat -- 日折现率
    ,effect_tm -- 生效时间
    ,invalid_tm -- 失效时间
    ,mtg_amt -- 抵押金额
    ,pay_freq_cd -- 付款频率代码
    ,rent_cont_idtfy_ser_num -- 租赁合同识别序列号
    ,rent_area -- 租赁面积
    ,inv_type_cd -- 发票类型代码
    ,rent_usage_type_cd -- 租赁用途类型代码
    ,mode_pay_cd -- 支付方式代码
    ,dedu_flg -- 可抵扣标志
    ,prepay_amorted_bal -- 预付待摊余额
    ,org_id -- 机构编号
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ast_lease_rent_asset_info_h partition for ('lmisf1')
where 0=1
;

create table ${iml_schema}.ast_lease_rent_asset_info_h_lmisf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.ast_lease_rent_asset_info_h partition for ('lmisf1') where 0=1;

create table ${iml_schema}.ast_lease_rent_asset_info_h_lmisf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.ast_lease_rent_asset_info_h partition for ('lmisf1') where 0=1;

-- 3.1 get new data into table
-- lmis_asset_lessee_info-1
insert into ${iml_schema}.ast_lease_rent_asset_info_h_lmisf1_tm(
    lease_asset_ser_num -- 承租资产序列号
    ,lp_id -- 法人编号
    ,asset_id -- 资产编号
    ,asset_ser_num -- 资产序列号
    ,lease_cont_ser_num -- 承租合同序列号
    ,cont_id -- 合同编号
    ,cont_name -- 合同名称
    ,cont_effect_dt -- 合同生效日期
    ,rent_ps_name -- 出租人名称
    ,acct_b_id -- 账簿编号
    ,asset_type_id -- 资产类型编号
    ,asset_name -- 资产名称
    ,asset_cate_ser_num -- 资产类别序列号
    ,asset_qtty -- 资产数量
    ,asset_status_cd -- 资产状态代码
    ,enter_acct_flg -- 入账标志
    ,rent_start_dt -- 租赁开始日期
    ,rent_exp_dt -- 租赁到期日期
    ,rent_tenor -- 租赁期限
    ,rent_tax_lmt -- 租赁税额
    ,plan_pay_pre_tax_tot -- 计划付款税前总额
    ,plan_pay_at_tot -- 计划付款税后总额
    ,year_disct_rat -- 年折现率
    ,day_disct_rat -- 日折现率
    ,effect_tm -- 生效时间
    ,invalid_tm -- 失效时间
    ,mtg_amt -- 抵押金额
    ,pay_freq_cd -- 付款频率代码
    ,rent_cont_idtfy_ser_num -- 租赁合同识别序列号
    ,rent_area -- 租赁面积
    ,inv_type_cd -- 发票类型代码
    ,rent_usage_type_cd -- 租赁用途类型代码
    ,mode_pay_cd -- 支付方式代码
    ,dedu_flg -- 可抵扣标志
    ,prepay_amorted_bal -- 预付待摊余额
    ,org_id -- 机构编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    TO_CHAR(P1.ID) -- 承租资产序列号
    ,'9999' -- 法人编号
    ,P1.ASSET_NUMBER -- 资产编号
    ,TO_CHAR(P1.ASSET_ID) -- 资产序列号
    ,TO_CHAR(P1.CONTRACT_ID) -- 承租合同序列号
    ,P1.CONTRACT_CODE -- 合同编号
    ,P1.CONTRACT_NAME -- 合同名称
    ,${iml_schema}.DATEFORMAT_MIN(TO_CHAR(P1.CONTRACT_EFFECT_DATE,'YYYYMMDD')) -- 合同生效日期
    ,P1.LESSOR -- 出租人名称
    ,P1.BOOK_CODE -- 账簿编号
    ,P1.ASSET_TYPE -- 资产类型编号
    ,P1.ASSET_NAME -- 资产名称
    ,TO_CHAR(P1.ASSET_CATEGORY_ID) -- 资产类别序列号
    ,TO_CHAR(P1.QUANTITY) -- 资产数量
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||P1.LESSEE_STATUS END -- 资产状态代码
    ,CASE WHEN R3.TARGET_CD_VAL IS NOT NULL THEN R3.TARGET_CD_VAL ELSE '@'||P1.ACCOUNT_STATUS END -- 入账标志
    ,${iml_schema}.DATEFORMAT_MIN(TO_CHAR(P1.LEASE_BEGIN_DATE,'YYYYMMDD')) -- 租赁开始日期
    ,${iml_schema}.DATEFORMAT_MAX2(TO_CHAR(P1.LEASE_END_DATE,'YYYYMMDD')) -- 租赁到期日期
    ,TO_CHAR(P1.LEASE_LIFE_MONTH) -- 租赁期限
    ,P1.AMOUNT_TAX -- 租赁税额
    ,P1.AMOUNT_NO_TAX -- 计划付款税前总额
    ,P1.AMOUNT_WITH_TAX -- 计划付款税后总额
    ,P1.YEAR_DISCOUNT_RATE -- 年折现率
    ,P1.DAY_DISCOUNT_RATE -- 日折现率
    ,P1.DATE_EFFECTIVE -- 生效时间
    ,P1.DATE_INEFFECTIVE -- 失效时间
    ,P1.DEPOSIT_AMOUNT -- 抵押金额
    ,CASE WHEN R4.TARGET_CD_VAL IS NOT NULL THEN R4.TARGET_CD_VAL ELSE '@'||P1.PAY_FREQUENCY END -- 付款频率代码
    ,TO_CHAR(P1.LEASE_ID) -- 租赁合同识别序列号
    ,P1.AREA -- 租赁面积
    ,CASE WHEN R5.TARGET_CD_VAL IS NOT NULL THEN R5.TARGET_CD_VAL ELSE '@'||P1.INVOICE_TYPE END -- 发票类型代码
    ,NVL(P1.LEASE_USAGE,'-'） -- 租赁用途类型代码
    ,CASE WHEN R7.TARGET_CD_VAL IS NOT NULL THEN R7.TARGET_CD_VAL ELSE '@'||P1.PAY_TYPE END -- 支付方式代码
    ,CASE WHEN R8.TARGET_CD_VAL IS NOT NULL THEN R8.TARGET_CD_VAL ELSE '@'||P1.DEDUCTION_FLAG END -- 可抵扣标志
    ,P1.LESSEE_PREPAY_AMOUNT -- 预付待摊余额
    ,P1.COMPANY_CODE -- 机构编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'lmis_asset_lessee_info' -- 源表名称
    ,'lmisf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.lmis_asset_lessee_info p1
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.LESSEE_STATUS = R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'LMIS'
        AND R2.SRC_TAB_EN_NAME= 'LMIS_ASSET_LESSEE_INFO'
        AND R2.SRC_FIELD_EN_NAME= 'LESSEE_STATUS'
        AND R2.TARGET_TAB_EN_NAME= 'AST_LEASE_RENT_ASSET_INFO_H'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'ASSET_STATUS_CD'
    left join ${iml_schema}.ref_pub_cd_map r3 on P1.ACCOUNT_STATUS = R3.SRC_CODE_VAL
        AND R3.SORC_SYS_CD= 'LMIS'
        AND R3.SRC_TAB_EN_NAME= 'LMIS_ASSET_LESSEE_INFO'
        AND R3.SRC_FIELD_EN_NAME= 'ACCOUNT_STATUS'
        AND R3.TARGET_TAB_EN_NAME= 'AST_LEASE_RENT_ASSET_INFO_H'
        AND R3.TARGET_TAB_FIELD_EN_NAME= 'ENTER_ACCT_FLG'
    left join ${iml_schema}.ref_pub_cd_map r4 on P1.PAY_FREQUENCY = R4.SRC_CODE_VAL
        AND R4.SORC_SYS_CD= 'LMIS'
        AND R4.SRC_TAB_EN_NAME= 'LMIS_ASSET_LESSEE_INFO'
        AND R4.SRC_FIELD_EN_NAME= 'PAY_FREQUENCY'
        AND R4.TARGET_TAB_EN_NAME= 'AST_LEASE_RENT_ASSET_INFO_H'
        AND R4.TARGET_TAB_FIELD_EN_NAME= 'PAY_FREQ_CD'
    left join ${iml_schema}.ref_pub_cd_map r5 on P1.INVOICE_TYPE = R5.SRC_CODE_VAL
        AND R5.SORC_SYS_CD= 'LMIS'
        AND R5.SRC_TAB_EN_NAME= 'LMIS_ASSET_LESSEE_INFO'
        AND R5.SRC_FIELD_EN_NAME= 'INVOICE_TYPE'
        AND R5.TARGET_TAB_EN_NAME= 'AST_LEASE_RENT_ASSET_INFO_H'
        AND R5.TARGET_TAB_FIELD_EN_NAME= 'INV_TYPE_CD'
    left join ${iml_schema}.ref_pub_cd_map r7 on P1.PAY_TYPE = R7.SRC_CODE_VAL
        AND R7.SORC_SYS_CD= 'LMIS'
        AND R7.SRC_TAB_EN_NAME= 'LMIS_ASSET_LESSEE_INFO'
        AND R7.SRC_FIELD_EN_NAME= 'PAY_TYPE'
        AND R7.TARGET_TAB_EN_NAME= 'AST_LEASE_RENT_ASSET_INFO_H'
        AND R7.TARGET_TAB_FIELD_EN_NAME= 'MODE_PAY_CD'
    left join ${iml_schema}.ref_pub_cd_map r8 on P1.DEDUCTION_FLAG = R8.SRC_CODE_VAL
        AND R8.SORC_SYS_CD= 'LMIS'
        AND R8.SRC_TAB_EN_NAME= 'LMIS_ASSET_LESSEE_INFO'
        AND R8.SRC_FIELD_EN_NAME= 'DEDUCTION_FLAG'
        AND R8.TARGET_TAB_EN_NAME= 'AST_LEASE_RENT_ASSET_INFO_H'
        AND R8.TARGET_TAB_FIELD_EN_NAME= 'DEDU_FLG'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
    AND P1.DATE_INEFFECTIVE = TO_DATE('00010101','YYYYMMDD')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.ast_lease_rent_asset_info_h_lmisf1_tm 
  	                                group by 
  	                                        lease_asset_ser_num
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
        into ${iml_schema}.ast_lease_rent_asset_info_h_lmisf1_cl(
            lease_asset_ser_num -- 承租资产序列号
    ,lp_id -- 法人编号
    ,asset_id -- 资产编号
    ,asset_ser_num -- 资产序列号
    ,lease_cont_ser_num -- 承租合同序列号
    ,cont_id -- 合同编号
    ,cont_name -- 合同名称
    ,cont_effect_dt -- 合同生效日期
    ,rent_ps_name -- 出租人名称
    ,acct_b_id -- 账簿编号
    ,asset_type_id -- 资产类型编号
    ,asset_name -- 资产名称
    ,asset_cate_ser_num -- 资产类别序列号
    ,asset_qtty -- 资产数量
    ,asset_status_cd -- 资产状态代码
    ,enter_acct_flg -- 入账标志
    ,rent_start_dt -- 租赁开始日期
    ,rent_exp_dt -- 租赁到期日期
    ,rent_tenor -- 租赁期限
    ,rent_tax_lmt -- 租赁税额
    ,plan_pay_pre_tax_tot -- 计划付款税前总额
    ,plan_pay_at_tot -- 计划付款税后总额
    ,year_disct_rat -- 年折现率
    ,day_disct_rat -- 日折现率
    ,effect_tm -- 生效时间
    ,invalid_tm -- 失效时间
    ,mtg_amt -- 抵押金额
    ,pay_freq_cd -- 付款频率代码
    ,rent_cont_idtfy_ser_num -- 租赁合同识别序列号
    ,rent_area -- 租赁面积
    ,inv_type_cd -- 发票类型代码
    ,rent_usage_type_cd -- 租赁用途类型代码
    ,mode_pay_cd -- 支付方式代码
    ,dedu_flg -- 可抵扣标志
    ,prepay_amorted_bal -- 预付待摊余额
    ,org_id -- 机构编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.ast_lease_rent_asset_info_h_lmisf1_op(
            lease_asset_ser_num -- 承租资产序列号
    ,lp_id -- 法人编号
    ,asset_id -- 资产编号
    ,asset_ser_num -- 资产序列号
    ,lease_cont_ser_num -- 承租合同序列号
    ,cont_id -- 合同编号
    ,cont_name -- 合同名称
    ,cont_effect_dt -- 合同生效日期
    ,rent_ps_name -- 出租人名称
    ,acct_b_id -- 账簿编号
    ,asset_type_id -- 资产类型编号
    ,asset_name -- 资产名称
    ,asset_cate_ser_num -- 资产类别序列号
    ,asset_qtty -- 资产数量
    ,asset_status_cd -- 资产状态代码
    ,enter_acct_flg -- 入账标志
    ,rent_start_dt -- 租赁开始日期
    ,rent_exp_dt -- 租赁到期日期
    ,rent_tenor -- 租赁期限
    ,rent_tax_lmt -- 租赁税额
    ,plan_pay_pre_tax_tot -- 计划付款税前总额
    ,plan_pay_at_tot -- 计划付款税后总额
    ,year_disct_rat -- 年折现率
    ,day_disct_rat -- 日折现率
    ,effect_tm -- 生效时间
    ,invalid_tm -- 失效时间
    ,mtg_amt -- 抵押金额
    ,pay_freq_cd -- 付款频率代码
    ,rent_cont_idtfy_ser_num -- 租赁合同识别序列号
    ,rent_area -- 租赁面积
    ,inv_type_cd -- 发票类型代码
    ,rent_usage_type_cd -- 租赁用途类型代码
    ,mode_pay_cd -- 支付方式代码
    ,dedu_flg -- 可抵扣标志
    ,prepay_amorted_bal -- 预付待摊余额
    ,org_id -- 机构编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.lease_asset_ser_num, o.lease_asset_ser_num) as lease_asset_ser_num -- 承租资产序列号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.asset_id, o.asset_id) as asset_id -- 资产编号
    ,nvl(n.asset_ser_num, o.asset_ser_num) as asset_ser_num -- 资产序列号
    ,nvl(n.lease_cont_ser_num, o.lease_cont_ser_num) as lease_cont_ser_num -- 承租合同序列号
    ,nvl(n.cont_id, o.cont_id) as cont_id -- 合同编号
    ,nvl(n.cont_name, o.cont_name) as cont_name -- 合同名称
    ,nvl(n.cont_effect_dt, o.cont_effect_dt) as cont_effect_dt -- 合同生效日期
    ,nvl(n.rent_ps_name, o.rent_ps_name) as rent_ps_name -- 出租人名称
    ,nvl(n.acct_b_id, o.acct_b_id) as acct_b_id -- 账簿编号
    ,nvl(n.asset_type_id, o.asset_type_id) as asset_type_id -- 资产类型编号
    ,nvl(n.asset_name, o.asset_name) as asset_name -- 资产名称
    ,nvl(n.asset_cate_ser_num, o.asset_cate_ser_num) as asset_cate_ser_num -- 资产类别序列号
    ,nvl(n.asset_qtty, o.asset_qtty) as asset_qtty -- 资产数量
    ,nvl(n.asset_status_cd, o.asset_status_cd) as asset_status_cd -- 资产状态代码
    ,nvl(n.enter_acct_flg, o.enter_acct_flg) as enter_acct_flg -- 入账标志
    ,nvl(n.rent_start_dt, o.rent_start_dt) as rent_start_dt -- 租赁开始日期
    ,nvl(n.rent_exp_dt, o.rent_exp_dt) as rent_exp_dt -- 租赁到期日期
    ,nvl(n.rent_tenor, o.rent_tenor) as rent_tenor -- 租赁期限
    ,nvl(n.rent_tax_lmt, o.rent_tax_lmt) as rent_tax_lmt -- 租赁税额
    ,nvl(n.plan_pay_pre_tax_tot, o.plan_pay_pre_tax_tot) as plan_pay_pre_tax_tot -- 计划付款税前总额
    ,nvl(n.plan_pay_at_tot, o.plan_pay_at_tot) as plan_pay_at_tot -- 计划付款税后总额
    ,nvl(n.year_disct_rat, o.year_disct_rat) as year_disct_rat -- 年折现率
    ,nvl(n.day_disct_rat, o.day_disct_rat) as day_disct_rat -- 日折现率
    ,nvl(n.effect_tm, o.effect_tm) as effect_tm -- 生效时间
    ,nvl(n.invalid_tm, o.invalid_tm) as invalid_tm -- 失效时间
    ,nvl(n.mtg_amt, o.mtg_amt) as mtg_amt -- 抵押金额
    ,nvl(n.pay_freq_cd, o.pay_freq_cd) as pay_freq_cd -- 付款频率代码
    ,nvl(n.rent_cont_idtfy_ser_num, o.rent_cont_idtfy_ser_num) as rent_cont_idtfy_ser_num -- 租赁合同识别序列号
    ,nvl(n.rent_area, o.rent_area) as rent_area -- 租赁面积
    ,nvl(n.inv_type_cd, o.inv_type_cd) as inv_type_cd -- 发票类型代码
    ,nvl(n.rent_usage_type_cd, o.rent_usage_type_cd) as rent_usage_type_cd -- 租赁用途类型代码
    ,nvl(n.mode_pay_cd, o.mode_pay_cd) as mode_pay_cd -- 支付方式代码
    ,nvl(n.dedu_flg, o.dedu_flg) as dedu_flg -- 可抵扣标志
    ,nvl(n.prepay_amorted_bal, o.prepay_amorted_bal) as prepay_amorted_bal -- 预付待摊余额
    ,nvl(n.org_id, o.org_id) as org_id -- 机构编号
    ,case when
            n.lease_asset_ser_num is null
            and n.lp_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.lease_asset_ser_num is null
            and n.lp_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.lease_asset_ser_num is null
            and n.lp_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ast_lease_rent_asset_info_h_lmisf1_tm n
    full join (select * from ${iml_schema}.ast_lease_rent_asset_info_h_lmisf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.lease_asset_ser_num = n.lease_asset_ser_num
            and o.lp_id = n.lp_id
where (
        o.lease_asset_ser_num is null
        and o.lp_id is null
    )
    or (
        n.lease_asset_ser_num is null
        and n.lp_id is null
    )
    or (
        o.asset_id <> n.asset_id
        or o.asset_ser_num <> n.asset_ser_num
        or o.lease_cont_ser_num <> n.lease_cont_ser_num
        or o.cont_id <> n.cont_id
        or o.cont_name <> n.cont_name
        or o.cont_effect_dt <> n.cont_effect_dt
        or o.rent_ps_name <> n.rent_ps_name
        or o.acct_b_id <> n.acct_b_id
        or o.asset_type_id <> n.asset_type_id
        or o.asset_name <> n.asset_name
        or o.asset_cate_ser_num <> n.asset_cate_ser_num
        or o.asset_qtty <> n.asset_qtty
        or o.asset_status_cd <> n.asset_status_cd
        or o.enter_acct_flg <> n.enter_acct_flg
        or o.rent_start_dt <> n.rent_start_dt
        or o.rent_exp_dt <> n.rent_exp_dt
        or o.rent_tenor <> n.rent_tenor
        or o.rent_tax_lmt <> n.rent_tax_lmt
        or o.plan_pay_pre_tax_tot <> n.plan_pay_pre_tax_tot
        or o.plan_pay_at_tot <> n.plan_pay_at_tot
        or o.year_disct_rat <> n.year_disct_rat
        or o.day_disct_rat <> n.day_disct_rat
        or o.effect_tm <> n.effect_tm
        or o.invalid_tm <> n.invalid_tm
        or o.mtg_amt <> n.mtg_amt
        or o.pay_freq_cd <> n.pay_freq_cd
        or o.rent_cont_idtfy_ser_num <> n.rent_cont_idtfy_ser_num
        or o.rent_area <> n.rent_area
        or o.inv_type_cd <> n.inv_type_cd
        or o.rent_usage_type_cd <> n.rent_usage_type_cd
        or o.mode_pay_cd <> n.mode_pay_cd
        or o.dedu_flg <> n.dedu_flg
        or o.prepay_amorted_bal <> n.prepay_amorted_bal
        or o.org_id <> n.org_id
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.ast_lease_rent_asset_info_h_lmisf1_cl(
            lease_asset_ser_num -- 承租资产序列号
    ,lp_id -- 法人编号
    ,asset_id -- 资产编号
    ,asset_ser_num -- 资产序列号
    ,lease_cont_ser_num -- 承租合同序列号
    ,cont_id -- 合同编号
    ,cont_name -- 合同名称
    ,cont_effect_dt -- 合同生效日期
    ,rent_ps_name -- 出租人名称
    ,acct_b_id -- 账簿编号
    ,asset_type_id -- 资产类型编号
    ,asset_name -- 资产名称
    ,asset_cate_ser_num -- 资产类别序列号
    ,asset_qtty -- 资产数量
    ,asset_status_cd -- 资产状态代码
    ,enter_acct_flg -- 入账标志
    ,rent_start_dt -- 租赁开始日期
    ,rent_exp_dt -- 租赁到期日期
    ,rent_tenor -- 租赁期限
    ,rent_tax_lmt -- 租赁税额
    ,plan_pay_pre_tax_tot -- 计划付款税前总额
    ,plan_pay_at_tot -- 计划付款税后总额
    ,year_disct_rat -- 年折现率
    ,day_disct_rat -- 日折现率
    ,effect_tm -- 生效时间
    ,invalid_tm -- 失效时间
    ,mtg_amt -- 抵押金额
    ,pay_freq_cd -- 付款频率代码
    ,rent_cont_idtfy_ser_num -- 租赁合同识别序列号
    ,rent_area -- 租赁面积
    ,inv_type_cd -- 发票类型代码
    ,rent_usage_type_cd -- 租赁用途类型代码
    ,mode_pay_cd -- 支付方式代码
    ,dedu_flg -- 可抵扣标志
    ,prepay_amorted_bal -- 预付待摊余额
    ,org_id -- 机构编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.ast_lease_rent_asset_info_h_lmisf1_op(
            lease_asset_ser_num -- 承租资产序列号
    ,lp_id -- 法人编号
    ,asset_id -- 资产编号
    ,asset_ser_num -- 资产序列号
    ,lease_cont_ser_num -- 承租合同序列号
    ,cont_id -- 合同编号
    ,cont_name -- 合同名称
    ,cont_effect_dt -- 合同生效日期
    ,rent_ps_name -- 出租人名称
    ,acct_b_id -- 账簿编号
    ,asset_type_id -- 资产类型编号
    ,asset_name -- 资产名称
    ,asset_cate_ser_num -- 资产类别序列号
    ,asset_qtty -- 资产数量
    ,asset_status_cd -- 资产状态代码
    ,enter_acct_flg -- 入账标志
    ,rent_start_dt -- 租赁开始日期
    ,rent_exp_dt -- 租赁到期日期
    ,rent_tenor -- 租赁期限
    ,rent_tax_lmt -- 租赁税额
    ,plan_pay_pre_tax_tot -- 计划付款税前总额
    ,plan_pay_at_tot -- 计划付款税后总额
    ,year_disct_rat -- 年折现率
    ,day_disct_rat -- 日折现率
    ,effect_tm -- 生效时间
    ,invalid_tm -- 失效时间
    ,mtg_amt -- 抵押金额
    ,pay_freq_cd -- 付款频率代码
    ,rent_cont_idtfy_ser_num -- 租赁合同识别序列号
    ,rent_area -- 租赁面积
    ,inv_type_cd -- 发票类型代码
    ,rent_usage_type_cd -- 租赁用途类型代码
    ,mode_pay_cd -- 支付方式代码
    ,dedu_flg -- 可抵扣标志
    ,prepay_amorted_bal -- 预付待摊余额
    ,org_id -- 机构编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.lease_asset_ser_num -- 承租资产序列号
    ,o.lp_id -- 法人编号
    ,o.asset_id -- 资产编号
    ,o.asset_ser_num -- 资产序列号
    ,o.lease_cont_ser_num -- 承租合同序列号
    ,o.cont_id -- 合同编号
    ,o.cont_name -- 合同名称
    ,o.cont_effect_dt -- 合同生效日期
    ,o.rent_ps_name -- 出租人名称
    ,o.acct_b_id -- 账簿编号
    ,o.asset_type_id -- 资产类型编号
    ,o.asset_name -- 资产名称
    ,o.asset_cate_ser_num -- 资产类别序列号
    ,o.asset_qtty -- 资产数量
    ,o.asset_status_cd -- 资产状态代码
    ,o.enter_acct_flg -- 入账标志
    ,o.rent_start_dt -- 租赁开始日期
    ,o.rent_exp_dt -- 租赁到期日期
    ,o.rent_tenor -- 租赁期限
    ,o.rent_tax_lmt -- 租赁税额
    ,o.plan_pay_pre_tax_tot -- 计划付款税前总额
    ,o.plan_pay_at_tot -- 计划付款税后总额
    ,o.year_disct_rat -- 年折现率
    ,o.day_disct_rat -- 日折现率
    ,o.effect_tm -- 生效时间
    ,o.invalid_tm -- 失效时间
    ,o.mtg_amt -- 抵押金额
    ,o.pay_freq_cd -- 付款频率代码
    ,o.rent_cont_idtfy_ser_num -- 租赁合同识别序列号
    ,o.rent_area -- 租赁面积
    ,o.inv_type_cd -- 发票类型代码
    ,o.rent_usage_type_cd -- 租赁用途类型代码
    ,o.mode_pay_cd -- 支付方式代码
    ,o.dedu_flg -- 可抵扣标志
    ,o.prepay_amorted_bal -- 预付待摊余额
    ,o.org_id -- 机构编号
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    , case when n.start_dt is not null
          then 'I'
          when o.end_dt >= to_date('${batch_date}','yyyymmdd')
          then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志 
    ,o.src_table_name -- 源表名称
    ,o.job_cd -- 任务编码
    ,o.etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ast_lease_rent_asset_info_h_lmisf1_bk o
    left join ${iml_schema}.ast_lease_rent_asset_info_h_lmisf1_op n
        on
            o.lease_asset_ser_num = n.lease_asset_ser_num
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.ast_lease_rent_asset_info_h_lmisf1_cl d
        on
            o.lease_asset_ser_num = d.lease_asset_ser_num
            and o.lp_id = d.lp_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.ast_lease_rent_asset_info_h;
--alter table ${iml_schema}.ast_lease_rent_asset_info_h truncate partition for ('lmisf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('ast_lease_rent_asset_info_h') 
               and substr(subpartition_name,1,8)=upper('p_lmisf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.ast_lease_rent_asset_info_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

alter table ${iml_schema}.ast_lease_rent_asset_info_h modify partition p_lmisf1 
add subpartition p_lmisf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.ast_lease_rent_asset_info_h exchange subpartition p_lmisf1_${batch_date} with table ${iml_schema}.ast_lease_rent_asset_info_h_lmisf1_cl;
alter table ${iml_schema}.ast_lease_rent_asset_info_h exchange subpartition p_lmisf1_20991231 with table ${iml_schema}.ast_lease_rent_asset_info_h_lmisf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.ast_lease_rent_asset_info_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.ast_lease_rent_asset_info_h_lmisf1_tm purge;
drop table ${iml_schema}.ast_lease_rent_asset_info_h_lmisf1_op purge;
drop table ${iml_schema}.ast_lease_rent_asset_info_h_lmisf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.ast_lease_rent_asset_info_h_lmisf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'ast_lease_rent_asset_info_h', partname => 'p_lmisf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
