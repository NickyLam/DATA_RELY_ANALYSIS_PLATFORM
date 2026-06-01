/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_prd_insure_fee_rat_info_h_inssf1
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
alter table ${iml_schema}.prd_insure_fee_rat_info_h add partition p_inssf1 values ('inssf1')(
        subpartition p_inssf1_19000101 values less than (to_date('20991231','yyyymmdd'))
        ,subpartition p_inssf1_20991231 values less than (maxvalue)
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.prd_insure_fee_rat_info_h_inssf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.prd_insure_fee_rat_info_h partition for ('inssf1')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.prd_insure_fee_rat_info_h_inssf1_tm purge;
drop table ${iml_schema}.prd_insure_fee_rat_info_h_inssf1_op purge;
drop table ${iml_schema}.prd_insure_fee_rat_info_h_inssf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.prd_insure_fee_rat_info_h_inssf1_tm nologging
compress ${option_switch} for query high
as select
    prod_id -- 产品编号
    ,lp_id -- 法人编号
    ,corp_cd -- 公司代码
    ,tran_type_cd -- 交易类型代码
    ,org_id -- 机构编号
    ,insure_mode_pay_cd -- 保险支付方式代码
    ,pay_year_term -- 缴费年期
    ,fee_mode_cd -- 费用模式代码
    ,calc_para -- 计算参数
    ,up_lolmi_ctrl_flg -- 上下限控制标志
    ,sig_max_amt -- 单笔最大金额
    ,sig_min_amt -- 单笔最小金额
    ,iss_fee -- 出单费
    ,tran_chn_cd -- 交易渠道代码
    ,guar_term_type_cd -- 保障年期类型代码
    ,guar_year_term -- 保障年期
    ,sig_lowt_permium -- 单笔最低保费
    ,sig_higt_permium -- 单笔最高保费
    ,insure_year -- 保险年度
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.prd_insure_fee_rat_info_h partition for ('inssf1')
where 0=1
;

create table ${iml_schema}.prd_insure_fee_rat_info_h_inssf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.prd_insure_fee_rat_info_h partition for ('inssf1') where 0=1;

create table ${iml_schema}.prd_insure_fee_rat_info_h_inssf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.prd_insure_fee_rat_info_h partition for ('inssf1') where 0=1;

-- 3.1 get new data into table
-- ifms_tbinsurerate-
insert into ${iml_schema}.prd_insure_fee_rat_info_h_inssf1_tm(
    prod_id -- 产品编号
    ,lp_id -- 法人编号
    ,corp_cd -- 公司代码
    ,tran_type_cd -- 交易类型代码
    ,org_id -- 机构编号
    ,insure_mode_pay_cd -- 保险支付方式代码
    ,pay_year_term -- 缴费年期
    ,fee_mode_cd -- 费用模式代码
    ,calc_para -- 计算参数
    ,up_lolmi_ctrl_flg -- 上下限控制标志
    ,sig_max_amt -- 单笔最大金额
    ,sig_min_amt -- 单笔最小金额
    ,iss_fee -- 出单费
    ,tran_chn_cd -- 交易渠道代码
    ,guar_term_type_cd -- 保障年期类型代码
    ,guar_year_term -- 保障年期
    ,sig_lowt_permium -- 单笔最低保费
    ,sig_higt_permium -- 单笔最高保费
    ,insure_year -- 保险年度
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.PRD_CODE -- 产品编号
    ,'9999' -- 法人编号
    ,P1.TA_CODE -- 公司代码
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.TRANS_TYPE END -- 交易类型代码
    ,P1.BRANCH_NO -- 机构编号
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||P1.PAY_YEAR_TYPE END -- 保险支付方式代码
    ,P1.PAY_YEAR -- 缴费年期
    ,CASE WHEN R3.TARGET_CD_VAL IS NOT NULL THEN R3.TARGET_CD_VAL ELSE '@'||P1.FEE_TYPE END -- 费用模式代码
    ,P1.FEE_NUMBER -- 计算参数
    ,NVL(trim(P1.UP_DOWN_FLAG),'-') -- 上下限控制标志
    ,P1.PER_MAX_AMT -- 单笔最大金额
    ,P1.PER_MIN_AMT -- 单笔最小金额
    ,P1.OFFER_CHARGE -- 出单费
    ,NVL(trim(P1.CHANNEL),'-') -- 交易渠道代码
    ,NVL(trim(P1.INSURE_YEAR_TYPE),'-') -- 保障年期类型代码
    ,P1.INSURE_YEAR -- 保障年期
    ,P1.MIN_INSURE_FEE -- 单笔最低保费
    ,P1.MAX_INSURE_FEE -- 单笔最高保费
    ,P1.INSURE_ANNUAL -- 保险年度
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ifms_tbinsurerate' -- 源表名称
    ,'inssf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ifms_tbinsurerate p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.TRANS_TYPE= R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'IFMS'
        AND R1.SRC_TAB_EN_NAME= 'IFMS_TBINSURERATE'
        AND R1.SRC_FIELD_EN_NAME= 'TRANS_TYPE'
        AND R1.TARGET_TAB_EN_NAME= 'PRD_INSURE_FEE_RAT_INFO_H'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'TRAN_TYPE_CD'
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.PAY_YEAR_TYPE= R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'IFMS'
        AND R2.SRC_TAB_EN_NAME= 'IFMS_TBINSURERATE'
        AND R2.SRC_FIELD_EN_NAME= 'PAY_YEAR_TYPE'
        AND R2.TARGET_TAB_EN_NAME= 'PRD_INSURE_FEE_RAT_INFO_H'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'INSURE_MODE_PAY_CD'
    left join ${iml_schema}.ref_pub_cd_map r3 on P1.FEE_TYPE= R3.SRC_CODE_VAL
        AND R3.SORC_SYS_CD= 'IFMS'
        AND R3.SRC_TAB_EN_NAME= 'IFMS_TBINSURERATE'
        AND R3.SRC_FIELD_EN_NAME= 'FEE_TYPE'
        AND R3.TARGET_TAB_EN_NAME= 'PRD_INSURE_FEE_RAT_INFO_H'
        AND R3.TARGET_TAB_FIELD_EN_NAME= 'FEE_MODE_CD'  
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

-- 3.2 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.prd_insure_fee_rat_info_h_inssf1_cl(
            prod_id -- 产品编号
    ,lp_id -- 法人编号
    ,corp_cd -- 公司代码
    ,tran_type_cd -- 交易类型代码
    ,org_id -- 机构编号
    ,insure_mode_pay_cd -- 保险支付方式代码
    ,pay_year_term -- 缴费年期
    ,fee_mode_cd -- 费用模式代码
    ,calc_para -- 计算参数
    ,up_lolmi_ctrl_flg -- 上下限控制标志
    ,sig_max_amt -- 单笔最大金额
    ,sig_min_amt -- 单笔最小金额
    ,iss_fee -- 出单费
    ,tran_chn_cd -- 交易渠道代码
    ,guar_term_type_cd -- 保障年期类型代码
    ,guar_year_term -- 保障年期
    ,sig_lowt_permium -- 单笔最低保费
    ,sig_higt_permium -- 单笔最高保费
    ,insure_year -- 保险年度
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.prd_insure_fee_rat_info_h_inssf1_op(
            prod_id -- 产品编号
    ,lp_id -- 法人编号
    ,corp_cd -- 公司代码
    ,tran_type_cd -- 交易类型代码
    ,org_id -- 机构编号
    ,insure_mode_pay_cd -- 保险支付方式代码
    ,pay_year_term -- 缴费年期
    ,fee_mode_cd -- 费用模式代码
    ,calc_para -- 计算参数
    ,up_lolmi_ctrl_flg -- 上下限控制标志
    ,sig_max_amt -- 单笔最大金额
    ,sig_min_amt -- 单笔最小金额
    ,iss_fee -- 出单费
    ,tran_chn_cd -- 交易渠道代码
    ,guar_term_type_cd -- 保障年期类型代码
    ,guar_year_term -- 保障年期
    ,sig_lowt_permium -- 单笔最低保费
    ,sig_higt_permium -- 单笔最高保费
    ,insure_year -- 保险年度
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.prod_id, o.prod_id) as prod_id -- 产品编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.corp_cd, o.corp_cd) as corp_cd -- 公司代码
    ,nvl(n.tran_type_cd, o.tran_type_cd) as tran_type_cd -- 交易类型代码
    ,nvl(n.org_id, o.org_id) as org_id -- 机构编号
    ,nvl(n.insure_mode_pay_cd, o.insure_mode_pay_cd) as insure_mode_pay_cd -- 保险支付方式代码
    ,nvl(n.pay_year_term, o.pay_year_term) as pay_year_term -- 缴费年期
    ,nvl(n.fee_mode_cd, o.fee_mode_cd) as fee_mode_cd -- 费用模式代码
    ,nvl(n.calc_para, o.calc_para) as calc_para -- 计算参数
    ,nvl(n.up_lolmi_ctrl_flg, o.up_lolmi_ctrl_flg) as up_lolmi_ctrl_flg -- 上下限控制标志
    ,nvl(n.sig_max_amt, o.sig_max_amt) as sig_max_amt -- 单笔最大金额
    ,nvl(n.sig_min_amt, o.sig_min_amt) as sig_min_amt -- 单笔最小金额
    ,nvl(n.iss_fee, o.iss_fee) as iss_fee -- 出单费
    ,nvl(n.tran_chn_cd, o.tran_chn_cd) as tran_chn_cd -- 交易渠道代码
    ,nvl(n.guar_term_type_cd, o.guar_term_type_cd) as guar_term_type_cd -- 保障年期类型代码
    ,nvl(n.guar_year_term, o.guar_year_term) as guar_year_term -- 保障年期
    ,nvl(n.sig_lowt_permium, o.sig_lowt_permium) as sig_lowt_permium -- 单笔最低保费
    ,nvl(n.sig_higt_permium, o.sig_higt_permium) as sig_higt_permium -- 单笔最高保费
    ,nvl(n.insure_year, o.insure_year) as insure_year -- 保险年度
    ,case when
            n.prod_id is null
            and n.lp_id is null
            and n.corp_cd is null
            and n.tran_type_cd is null
            and n.org_id is null
            and n.insure_mode_pay_cd is null
            and n.pay_year_term is null
            and n.guar_term_type_cd is null
            and n.guar_year_term is null
            and n.sig_lowt_permium is null
            and n.insure_year is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.prod_id is null
            and n.lp_id is null
            and n.corp_cd is null
            and n.tran_type_cd is null
            and n.org_id is null
            and n.insure_mode_pay_cd is null
            and n.pay_year_term is null
            and n.guar_term_type_cd is null
            and n.guar_year_term is null
            and n.sig_lowt_permium is null
            and n.insure_year is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.prod_id is null
            and n.lp_id is null
            and n.corp_cd is null
            and n.tran_type_cd is null
            and n.org_id is null
            and n.insure_mode_pay_cd is null
            and n.pay_year_term is null
            and n.guar_term_type_cd is null
            and n.guar_year_term is null
            and n.sig_lowt_permium is null
            and n.insure_year is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.prd_insure_fee_rat_info_h_inssf1_tm n
    full join (select * from ${iml_schema}.prd_insure_fee_rat_info_h_inssf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.prod_id = n.prod_id
            and o.lp_id = n.lp_id
            and o.corp_cd = n.corp_cd
            and o.tran_type_cd = n.tran_type_cd
            and o.org_id = n.org_id
            and o.insure_mode_pay_cd = n.insure_mode_pay_cd
            and o.pay_year_term = n.pay_year_term
            and o.guar_term_type_cd = n.guar_term_type_cd
            and o.guar_year_term = n.guar_year_term
            and o.sig_lowt_permium = n.sig_lowt_permium
            and o.insure_year = n.insure_year
where (
        o.prod_id is null
        and o.lp_id is null
        and o.corp_cd is null
        and o.tran_type_cd is null
        and o.org_id is null
        and o.insure_mode_pay_cd is null
        and o.pay_year_term is null
        and o.guar_term_type_cd is null
        and o.guar_year_term is null
        and o.sig_lowt_permium is null
        and o.insure_year is null
    )
    or (
        n.prod_id is null
        and n.lp_id is null
        and n.corp_cd is null
        and n.tran_type_cd is null
        and n.org_id is null
        and n.insure_mode_pay_cd is null
        and n.pay_year_term is null
        and n.guar_term_type_cd is null
        and n.guar_year_term is null
        and n.sig_lowt_permium is null
        and n.insure_year is null
    )
    or (
        o.fee_mode_cd <> n.fee_mode_cd
        or o.calc_para <> n.calc_para
        or o.up_lolmi_ctrl_flg <> n.up_lolmi_ctrl_flg
        or o.sig_max_amt <> n.sig_max_amt
        or o.sig_min_amt <> n.sig_min_amt
        or o.iss_fee <> n.iss_fee
        or o.tran_chn_cd <> n.tran_chn_cd
        or o.sig_higt_permium <> n.sig_higt_permium
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.prd_insure_fee_rat_info_h_inssf1_cl(
            prod_id -- 产品编号
    ,lp_id -- 法人编号
    ,corp_cd -- 公司代码
    ,tran_type_cd -- 交易类型代码
    ,org_id -- 机构编号
    ,insure_mode_pay_cd -- 保险支付方式代码
    ,pay_year_term -- 缴费年期
    ,fee_mode_cd -- 费用模式代码
    ,calc_para -- 计算参数
    ,up_lolmi_ctrl_flg -- 上下限控制标志
    ,sig_max_amt -- 单笔最大金额
    ,sig_min_amt -- 单笔最小金额
    ,iss_fee -- 出单费
    ,tran_chn_cd -- 交易渠道代码
    ,guar_term_type_cd -- 保障年期类型代码
    ,guar_year_term -- 保障年期
    ,sig_lowt_permium -- 单笔最低保费
    ,sig_higt_permium -- 单笔最高保费
    ,insure_year -- 保险年度
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.prd_insure_fee_rat_info_h_inssf1_op(
            prod_id -- 产品编号
    ,lp_id -- 法人编号
    ,corp_cd -- 公司代码
    ,tran_type_cd -- 交易类型代码
    ,org_id -- 机构编号
    ,insure_mode_pay_cd -- 保险支付方式代码
    ,pay_year_term -- 缴费年期
    ,fee_mode_cd -- 费用模式代码
    ,calc_para -- 计算参数
    ,up_lolmi_ctrl_flg -- 上下限控制标志
    ,sig_max_amt -- 单笔最大金额
    ,sig_min_amt -- 单笔最小金额
    ,iss_fee -- 出单费
    ,tran_chn_cd -- 交易渠道代码
    ,guar_term_type_cd -- 保障年期类型代码
    ,guar_year_term -- 保障年期
    ,sig_lowt_permium -- 单笔最低保费
    ,sig_higt_permium -- 单笔最高保费
    ,insure_year -- 保险年度
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.prod_id -- 产品编号
    ,o.lp_id -- 法人编号
    ,o.corp_cd -- 公司代码
    ,o.tran_type_cd -- 交易类型代码
    ,o.org_id -- 机构编号
    ,o.insure_mode_pay_cd -- 保险支付方式代码
    ,o.pay_year_term -- 缴费年期
    ,o.fee_mode_cd -- 费用模式代码
    ,o.calc_para -- 计算参数
    ,o.up_lolmi_ctrl_flg -- 上下限控制标志
    ,o.sig_max_amt -- 单笔最大金额
    ,o.sig_min_amt -- 单笔最小金额
    ,o.iss_fee -- 出单费
    ,o.tran_chn_cd -- 交易渠道代码
    ,o.guar_term_type_cd -- 保障年期类型代码
    ,o.guar_year_term -- 保障年期
    ,o.sig_lowt_permium -- 单笔最低保费
    ,o.sig_higt_permium -- 单笔最高保费
    ,o.insure_year -- 保险年度
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,o.src_table_name -- 源表名称
    ,o.job_cd -- 任务编码
    ,o.etl_timestamp -- ETL处理时间戳
from ${iml_schema}.prd_insure_fee_rat_info_h_inssf1_bk o
    left join ${iml_schema}.prd_insure_fee_rat_info_h_inssf1_op n
        on
            o.prod_id = n.prod_id
            and o.lp_id = n.lp_id
            and o.corp_cd = n.corp_cd
            and o.tran_type_cd = n.tran_type_cd
            and o.org_id = n.org_id
            and o.insure_mode_pay_cd = n.insure_mode_pay_cd
            and o.pay_year_term = n.pay_year_term
            and o.guar_term_type_cd = n.guar_term_type_cd
            and o.guar_year_term = n.guar_year_term
            and o.sig_lowt_permium = n.sig_lowt_permium
            and o.insure_year = n.insure_year
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.prd_insure_fee_rat_info_h_inssf1_cl d
        on
            o.prod_id = d.prod_id
            and o.lp_id = d.lp_id
            and o.corp_cd = d.corp_cd
            and o.tran_type_cd = d.tran_type_cd
            and o.org_id = d.org_id
            and o.insure_mode_pay_cd = d.insure_mode_pay_cd
            and o.pay_year_term = d.pay_year_term
            and o.guar_term_type_cd = d.guar_term_type_cd
            and o.guar_year_term = d.guar_year_term
            and o.sig_lowt_permium = d.sig_lowt_permium
            and o.insure_year = d.insure_year
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iml_schema}.prd_insure_fee_rat_info_h;
alter table ${iml_schema}.prd_insure_fee_rat_info_h truncate partition for ('inssf1') reuse storage;

-- 4.2 exchange partition
alter table ${iml_schema}.prd_insure_fee_rat_info_h exchange subpartition p_inssf1_19000101 with table ${iml_schema}.prd_insure_fee_rat_info_h_inssf1_cl;
alter table ${iml_schema}.prd_insure_fee_rat_info_h exchange subpartition p_inssf1_20991231 with table ${iml_schema}.prd_insure_fee_rat_info_h_inssf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.prd_insure_fee_rat_info_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.prd_insure_fee_rat_info_h_inssf1_tm purge;
drop table ${iml_schema}.prd_insure_fee_rat_info_h_inssf1_op purge;
drop table ${iml_schema}.prd_insure_fee_rat_info_h_inssf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.prd_insure_fee_rat_info_h_inssf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'prd_insure_fee_rat_info_h', partname => 'p_inssf1_20991231', granularity => 'SUBPARTITION', degree => 8, cascade => true);
