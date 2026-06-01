/*
Purpose:    整全模型层-快照表脚本，备份目标表当月数据（不含当天），用前一天数据与当天数据整合后插入到目标表中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_prd_am_prod_sell_para_famsf2
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
drop table ${iml_schema}.prd_am_prod_sell_para_famsf2_tm purge;
drop table ${iml_schema}.prd_am_prod_sell_para_famsf2_ex purge;

-- 2.2 add partition for target table
alter table ${iml_schema}.prd_am_prod_sell_para add partition p_famsf2 values ('famsf2')(
        subpartition p_famsf2_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.prd_am_prod_sell_para modify partition p_famsf2
    add subpartition p_famsf2_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

-- 2.3 if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.prd_am_prod_sell_para_famsf2_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.prd_am_prod_sell_para partition for ('famsf2')
where create_dt < to_date('${batch_date}','yyyymmdd')
;

-- 2.4 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.prd_am_prod_sell_para_famsf2_tm
compress ${option_switch} for query high
as
select
    prod_id -- 产品编号
    ,lp_id -- 法人编号
    ,am_prod_id -- 资管产品编号
    ,finc_prod_id -- 理财产品编号
    ,sell_chn_cd_comb -- 销售渠道代码组合
    ,sell_rg_cd_comb -- 销售地区代码组合
    ,target_cust_type_cd_comb -- 目标客户类型代码组合
    ,coll_amt_uplmi -- 募集金额上限
    ,coll_amt_lolmi -- 募集金额下限
    ,plan_coll_amt -- 计划募集金额
    ,subscr_amt_sp -- 认购金额起点
    ,least_supp_amt -- 最少追加金额
    ,huge_redem_ratio -- 巨额赎回比例
    ,lowt_book_lot -- 最低账面份额
    ,lowt_redem_lot -- 最低赎回份额
    ,inpwned_flg -- 可质押标志
    ,fir_coll_start_dt -- 首次募集开始日期
    ,fir_coll_end_dt -- 首次募集结束日期
    ,supt_consmt_flg -- 支持代销标志
    ,allow_adv_termnt_flg -- 允许提前终止标志
    ,allow_cust_redem_flg -- 允许客户赎回标志
    ,deflt_redem_flg -- 可违约赎回标志
    ,advd_found_flg -- 可提前成立标志
    ,invest_flg -- 可续投标志
    ,ibank_cust_id_comb -- 同业客户编号组合
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.prd_am_prod_sell_para
where 0=1;

-- 2.5 create temp table
create table ${iml_schema}.prd_am_prod_sell_para_famsf2_ex nologging
compress ${option_switch} for query high
as select * from ${iml_schema}.prd_am_prod_sell_para partition for ('famsf2') where 0=1;

-- 2.1 insert data to tm table
-- fams_prd_sale_param-1
insert into ${iml_schema}.prd_am_prod_sell_para_famsf2_tm(
    prod_id -- 产品编号
    ,lp_id -- 法人编号
    ,am_prod_id -- 资管产品编号
    ,finc_prod_id -- 理财产品编号
    ,sell_chn_cd_comb -- 销售渠道代码组合
    ,sell_rg_cd_comb -- 销售地区代码组合
    ,target_cust_type_cd_comb -- 目标客户类型代码组合
    ,coll_amt_uplmi -- 募集金额上限
    ,coll_amt_lolmi -- 募集金额下限
    ,plan_coll_amt -- 计划募集金额
    ,subscr_amt_sp -- 认购金额起点
    ,least_supp_amt -- 最少追加金额
    ,huge_redem_ratio -- 巨额赎回比例
    ,lowt_book_lot -- 最低账面份额
    ,lowt_redem_lot -- 最低赎回份额
    ,inpwned_flg -- 可质押标志
    ,fir_coll_start_dt -- 首次募集开始日期
    ,fir_coll_end_dt -- 首次募集结束日期
    ,supt_consmt_flg -- 支持代销标志
    ,allow_adv_termnt_flg -- 允许提前终止标志
    ,allow_cust_redem_flg -- 允许客户赎回标志
    ,deflt_redem_flg -- 可违约赎回标志
    ,advd_found_flg -- 可提前成立标志
    ,invest_flg -- 可续投标志
    ,ibank_cust_id_comb -- 同业客户编号组合
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '223002'||P1.FINPROD_ID -- 产品编号
    ,'9999' -- 法人编号
    ,P1.FINPROD_ID -- 资管产品编号
    ,substr(p1.finprod_id,5) -- 理财产品编号
    ,P1.SALE_CHANNEL -- 销售渠道代码组合
    ,P1.SALE_AREA -- 销售地区代码组合
    ,substr(P1.INVESTOR_TYPE,1,100) -- 目标客户类型代码组合
    ,P1.SALE_MAX -- 募集金额上限
    ,P1.SALE_MIN -- 募集金额下限
    ,P1.RAISE_AMT_PLAN -- 计划募集金额
    ,P1.TOFF_START -- 认购金额起点
    ,P1.LOWEST_AMT -- 最少追加金额
    ,P1.HUGE_RED_RATIO*100 -- 巨额赎回比例
    ,P1.MIN_PAPER_QTY -- 最低账面份额
    ,P1.MIN_REDM_QTY -- 最低赎回份额
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE substr('@'||P1.CAN_PLGE,1,10) END -- 可质押标志
    ,P1.FIRST_SALE_VDATE -- 首次募集开始日期
    ,P1.FIRST_SALE_MDATE -- 首次募集结束日期
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE substr('@'||P1.CONSIGNMENT_FLAG,1,10) END -- 支持代销标志
    ,CASE WHEN R3.TARGET_CD_VAL IS NOT NULL THEN R3.TARGET_CD_VAL ELSE substr('@'||P1.BEFOREEND_FLAG,1,10) END -- 允许提前终止标志
    ,CASE WHEN R4.TARGET_CD_VAL IS NOT NULL THEN R4.TARGET_CD_VAL ELSE substr('@'||P1.RED_FLAG,1,10) END -- 允许客户赎回标志
    ,CASE WHEN R5.TARGET_CD_VAL IS NOT NULL THEN R5.TARGET_CD_VAL ELSE substr('@'||P1.DEFAULTRED_FLAG,1,10) END -- 可违约赎回标志
    ,CASE WHEN R6.TARGET_CD_VAL IS NOT NULL THEN R6.TARGET_CD_VAL ELSE substr('@'||P1.BEFOREESTABLISH_FLAG,1,10) END -- 可提前成立标志
    ,CASE WHEN R7.TARGET_CD_VAL IS NOT NULL THEN R7.TARGET_CD_VAL ELSE substr('@'||P1.CONTINUE_FLAG,1,10) END -- 可续投标志
    ,substr(P1.SAME_ORG,1,100) -- 同业客户编号组合
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'fams_prd_sale_param' -- 源表名称
    ,'famsf2' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.fams_prd_sale_param p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.CAN_PLGE= R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'FAMS'
        AND R1.SRC_TAB_EN_NAME= 'FAMS_PRD_SALE_PARAM'
        AND R1.SRC_FIELD_EN_NAME= 'CAN_PLGE'
        AND R1.TARGET_TAB_EN_NAME= 'PRD_AM_PROD_SELL_PARA'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'INPWNED_FLG'
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.CONSIGNMENT_FLAG= R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'FAMS'
        AND R2.SRC_TAB_EN_NAME= 'FAMS_PRD_SALE_PARAM'
        AND R2.SRC_FIELD_EN_NAME= 'CONSIGNMENT_FLAG'
        AND R2.TARGET_TAB_EN_NAME= 'PRD_AM_PROD_SELL_PARA'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'SUPT_CONSMT_FLG'
    left join ${iml_schema}.ref_pub_cd_map r3 on P1.BEFOREEND_FLAG= R3.SRC_CODE_VAL
        AND R3.SORC_SYS_CD= 'FAMS'
        AND R3.SRC_TAB_EN_NAME= 'FAMS_PRD_SALE_PARAM'
        AND R3.SRC_FIELD_EN_NAME= 'BEFOREEND_FLAG'
        AND R3.TARGET_TAB_EN_NAME= 'PRD_AM_PROD_SELL_PARA'
        AND R3.TARGET_TAB_FIELD_EN_NAME= 'ALLOW_ADV_TERMNT_FLG'
    left join ${iml_schema}.ref_pub_cd_map r4 on P1.RED_FLAG= R4.SRC_CODE_VAL
        AND R4.SORC_SYS_CD= 'FAMS'
        AND R4.SRC_TAB_EN_NAME= 'FAMS_PRD_SALE_PARAM'
        AND R4.SRC_FIELD_EN_NAME= 'RED_FLAG'
        AND R4.TARGET_TAB_EN_NAME= 'PRD_AM_PROD_SELL_PARA'
        AND R4.TARGET_TAB_FIELD_EN_NAME= 'ALLOW_CUST_REDEM_FLG'
    left join ${iml_schema}.ref_pub_cd_map r5 on P1.DEFAULTRED_FLAG= R5.SRC_CODE_VAL
        AND R5.SORC_SYS_CD= 'FAMS'
        AND R5.SRC_TAB_EN_NAME= 'FAMS_PRD_SALE_PARAM'
        AND R5.SRC_FIELD_EN_NAME= 'DEFAULTRED_FLAG'
        AND R5.TARGET_TAB_EN_NAME= 'PRD_AM_PROD_SELL_PARA'
        AND R5.TARGET_TAB_FIELD_EN_NAME= 'DEFLT_REDEM_FLG'
    left join ${iml_schema}.ref_pub_cd_map r6 on P1.BEFOREESTABLISH_FLAG= R6.SRC_CODE_VAL
        AND R6.SORC_SYS_CD= 'FAMS'
        AND R6.SRC_TAB_EN_NAME= 'FAMS_PRD_SALE_PARAM'
        AND R6.SRC_FIELD_EN_NAME= 'BEFOREESTABLISH_FLAG'
        AND R6.TARGET_TAB_EN_NAME= 'PRD_AM_PROD_SELL_PARA'
        AND R6.TARGET_TAB_FIELD_EN_NAME= 'ADVD_FOUND_FLG'
    left join ${iml_schema}.ref_pub_cd_map r7 on P1.CONTINUE_FLAG= R7.SRC_CODE_VAL
        AND R7.SORC_SYS_CD= 'FAMS'
        AND R7.SRC_TAB_EN_NAME= 'FAMS_PRD_SALE_PARAM'
        AND R7.SRC_FIELD_EN_NAME= 'CONTINUE_FLAG'
        AND R7.TARGET_TAB_EN_NAME= 'PRD_AM_PROD_SELL_PARA'
        AND R7.TARGET_TAB_FIELD_EN_NAME= 'INVEST_FLG'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;



whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.prd_am_prod_sell_para_famsf2_tm 
  	                                group by 
  	                                        prod_id
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

-- 2.2 chage data and update_dt, create_dt, etl_dt
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${iml_schema}.prd_am_prod_sell_para_famsf2_ex(
    prod_id -- 产品编号
    ,lp_id -- 法人编号
    ,am_prod_id -- 资管产品编号
    ,finc_prod_id -- 理财产品编号
    ,sell_chn_cd_comb -- 销售渠道代码组合
    ,sell_rg_cd_comb -- 销售地区代码组合
    ,target_cust_type_cd_comb -- 目标客户类型代码组合
    ,coll_amt_uplmi -- 募集金额上限
    ,coll_amt_lolmi -- 募集金额下限
    ,plan_coll_amt -- 计划募集金额
    ,subscr_amt_sp -- 认购金额起点
    ,least_supp_amt -- 最少追加金额
    ,huge_redem_ratio -- 巨额赎回比例
    ,lowt_book_lot -- 最低账面份额
    ,lowt_redem_lot -- 最低赎回份额
    ,inpwned_flg -- 可质押标志
    ,fir_coll_start_dt -- 首次募集开始日期
    ,fir_coll_end_dt -- 首次募集结束日期
    ,supt_consmt_flg -- 支持代销标志
    ,allow_adv_termnt_flg -- 允许提前终止标志
    ,allow_cust_redem_flg -- 允许客户赎回标志
    ,deflt_redem_flg -- 可违约赎回标志
    ,advd_found_flg -- 可提前成立标志
    ,invest_flg -- 可续投标志
    ,ibank_cust_id_comb -- 同业客户编号组合
    ,create_dt -- 创建日期
    ,update_dt -- 更新日期
    ,etl_dt -- ETL处理日期
    ,id_mark -- 增删标志
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    nvl(n.prod_id, o.prod_id) as prod_id -- 产品编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.am_prod_id, o.am_prod_id) as am_prod_id -- 资管产品编号
    ,nvl(n.finc_prod_id, o.finc_prod_id) as finc_prod_id -- 理财产品编号
    ,nvl(n.sell_chn_cd_comb, o.sell_chn_cd_comb) as sell_chn_cd_comb -- 销售渠道代码组合
    ,nvl(n.sell_rg_cd_comb, o.sell_rg_cd_comb) as sell_rg_cd_comb -- 销售地区代码组合
    ,nvl(n.target_cust_type_cd_comb, o.target_cust_type_cd_comb) as target_cust_type_cd_comb -- 目标客户类型代码组合
    ,nvl(n.coll_amt_uplmi, o.coll_amt_uplmi) as coll_amt_uplmi -- 募集金额上限
    ,nvl(n.coll_amt_lolmi, o.coll_amt_lolmi) as coll_amt_lolmi -- 募集金额下限
    ,nvl(n.plan_coll_amt, o.plan_coll_amt) as plan_coll_amt -- 计划募集金额
    ,nvl(n.subscr_amt_sp, o.subscr_amt_sp) as subscr_amt_sp -- 认购金额起点
    ,nvl(n.least_supp_amt, o.least_supp_amt) as least_supp_amt -- 最少追加金额
    ,nvl(n.huge_redem_ratio, o.huge_redem_ratio) as huge_redem_ratio -- 巨额赎回比例
    ,nvl(n.lowt_book_lot, o.lowt_book_lot) as lowt_book_lot -- 最低账面份额
    ,nvl(n.lowt_redem_lot, o.lowt_redem_lot) as lowt_redem_lot -- 最低赎回份额
    ,nvl(n.inpwned_flg, o.inpwned_flg) as inpwned_flg -- 可质押标志
    ,nvl(n.fir_coll_start_dt, o.fir_coll_start_dt) as fir_coll_start_dt -- 首次募集开始日期
    ,nvl(n.fir_coll_end_dt, o.fir_coll_end_dt) as fir_coll_end_dt -- 首次募集结束日期
    ,nvl(n.supt_consmt_flg, o.supt_consmt_flg) as supt_consmt_flg -- 支持代销标志
    ,nvl(n.allow_adv_termnt_flg, o.allow_adv_termnt_flg) as allow_adv_termnt_flg -- 允许提前终止标志
    ,nvl(n.allow_cust_redem_flg, o.allow_cust_redem_flg) as allow_cust_redem_flg -- 允许客户赎回标志
    ,nvl(n.deflt_redem_flg, o.deflt_redem_flg) as deflt_redem_flg -- 可违约赎回标志
    ,nvl(n.advd_found_flg, o.advd_found_flg) as advd_found_flg -- 可提前成立标志
    ,nvl(n.invest_flg, o.invest_flg) as invest_flg -- 可续投标志
    ,nvl(n.ibank_cust_id_comb, o.ibank_cust_id_comb) as ibank_cust_id_comb -- 同业客户编号组合
    ,nvl(o.create_dt, to_date('${batch_date}', 'yyyymmdd')) as create_dt -- 创建日期
    ,case when (
                o.prod_id is null
                and o.lp_id is null
            ) or (
                o.am_prod_id <> n.am_prod_id
                or o.finc_prod_id <> n.finc_prod_id
                or o.sell_chn_cd_comb <> n.sell_chn_cd_comb
                or o.sell_rg_cd_comb <> n.sell_rg_cd_comb
                or o.target_cust_type_cd_comb <> n.target_cust_type_cd_comb
                or o.coll_amt_uplmi <> n.coll_amt_uplmi
                or o.coll_amt_lolmi <> n.coll_amt_lolmi
                or o.plan_coll_amt <> n.plan_coll_amt
                or o.subscr_amt_sp <> n.subscr_amt_sp
                or o.least_supp_amt <> n.least_supp_amt
                or o.huge_redem_ratio <> n.huge_redem_ratio
                or o.lowt_book_lot <> n.lowt_book_lot
                or o.lowt_redem_lot <> n.lowt_redem_lot
                or o.inpwned_flg <> n.inpwned_flg
                or o.fir_coll_start_dt <> n.fir_coll_start_dt
                or o.fir_coll_end_dt <> n.fir_coll_end_dt
                or o.supt_consmt_flg <> n.supt_consmt_flg
                or o.allow_adv_termnt_flg <> n.allow_adv_termnt_flg
                or o.allow_cust_redem_flg <> n.allow_cust_redem_flg
                or o.deflt_redem_flg <> n.deflt_redem_flg
                or o.advd_found_flg <> n.advd_found_flg
                or o.invest_flg <> n.invest_flg
                or o.ibank_cust_id_comb <> n.ibank_cust_id_comb
            ) or (
                 case when (
                           n.prod_id is null
                           and n.lp_id is null
                         )
                      then 'D'
                 else 'I'
                 end
            )<> o.id_mark
        then to_date('${batch_date}', 'yyyymmdd')
        else o.update_dt
     end as update_dt -- 更新日期
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt -- ETL处理日期
    ,case when (
                n.prod_id is null
                and n.lp_id is null
            )
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.prd_am_prod_sell_para_famsf2_tm n
    full join ${iml_schema}.prd_am_prod_sell_para_famsf2_bk o
        on
            o.prod_id = n.prod_id
            and o.lp_id = n.lp_id
;
commit;

-- 3.1 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.prd_am_prod_sell_para truncate partition for ('famsf2') reuse storage;

-- 3.2 exchage tm table and target table
alter table ${iml_schema}.prd_am_prod_sell_para exchange subpartition p_famsf2_${batch_date} with table ${iml_schema}.prd_am_prod_sell_para_famsf2_ex;

-- 3.3 drop subpartition last_date partition
whenever sqlerror continue none ;
alter table ${iml_schema}.prd_am_prod_sell_para drop subpartition p_famsf2_${last_date} update global indexes;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.prd_am_prod_sell_para to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.prd_am_prod_sell_para_famsf2_tm purge;
drop table ${iml_schema}.prd_am_prod_sell_para_famsf2_ex purge;
drop table ${iml_schema}.prd_am_prod_sell_para_famsf2_bk purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'prd_am_prod_sell_para', partname => 'p_famsf2_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);