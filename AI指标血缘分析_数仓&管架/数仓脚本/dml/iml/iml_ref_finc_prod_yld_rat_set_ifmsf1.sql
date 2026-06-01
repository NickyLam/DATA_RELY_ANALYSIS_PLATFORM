/*
Purpose:    整全模型层-快照表脚本，备份目标表当月数据（不含当天），用前一天数据与当天数据整合后插入到目标表中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_ref_finc_prod_yld_rat_set_ifmsf1
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
drop table ${iml_schema}.ref_finc_prod_yld_rat_set_ifmsf1_tm purge;
drop table ${iml_schema}.ref_finc_prod_yld_rat_set_ifmsf1_ex purge;

-- 2.2 add partition for target table
alter table ${iml_schema}.ref_finc_prod_yld_rat_set add partition p_ifmsf1 values ('ifmsf1')(
        subpartition p_ifmsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.ref_finc_prod_yld_rat_set modify partition p_ifmsf1
    add subpartition p_ifmsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

-- 2.3 if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.ref_finc_prod_yld_rat_set_ifmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.ref_finc_prod_yld_rat_set partition for ('ifmsf1')
where create_dt < to_date('${batch_date}','yyyymmdd')
;

-- 2.4 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.ref_finc_prod_yld_rat_set_ifmsf1_tm
compress ${option_switch} for query high
as
select
    flow_num -- 流水号
    ,lp_id -- 法人编号
    ,prod_id -- 产品编号
    ,vp -- 有效期
    ,prft_mode_cd -- 收益模式代码
    ,seller_cd -- 销售商代码
    ,cust_type_cd -- 客户类型代码
    ,sell_type_cd -- 销售类型代码
    ,hold_days -- 持有天数
    ,hold_min_days -- 持有最小天数
    ,hold_max_days -- 持有最大天数
    ,hold_min_amt -- 持有最小金额
    ,hold_max_amt -- 持有最大金额
    ,cust_yld_rat -- 客户收益率
    ,bank_yld_rat -- 银行收益率
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ref_finc_prod_yld_rat_set
where 0=1;

-- 2.5 create temp table
create table ${iml_schema}.ref_finc_prod_yld_rat_set_ifmsf1_ex nologging
compress ${option_switch} for query high
as select * from ${iml_schema}.ref_finc_prod_yld_rat_set partition for ('ifmsf1') where 0=1;

-- 2.1 insert data to tm table
-- ifms_tbpriceset-
insert into ${iml_schema}.ref_finc_prod_yld_rat_set_ifmsf1_tm(
    flow_num -- 流水号
    ,lp_id -- 法人编号
    ,prod_id -- 产品编号
    ,vp -- 有效期
    ,prft_mode_cd -- 收益模式代码
    ,seller_cd -- 销售商代码
    ,cust_type_cd -- 客户类型代码
    ,sell_type_cd -- 销售类型代码
    ,hold_days -- 持有天数
    ,hold_min_days -- 持有最小天数
    ,hold_max_days -- 持有最大天数
    ,hold_min_amt -- 持有最小金额
    ,hold_max_amt -- 持有最大金额
    ,cust_yld_rat -- 客户收益率
    ,bank_yld_rat -- 银行收益率
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.SERIAL_NO -- 流水号
    ,'9999' -- 法人编号
    ,P1.PRD_CODE -- 产品编号
    ,${iml_schema}.DATEFORMAT_MAX(TO_CHAR(P1.VALID_DATE)) -- 有效期
    ,P1.PRICE_MODE -- 收益模式代码
    ,P1.SELLER_CODE -- 销售商代码
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.CLIENT_TYPE END -- 客户类型代码
    ,NVL(TRIM(P1.SELLER_TYPE),'-') -- 销售类型代码
    ,P1.HOLD_DAYS -- 持有天数
    ,P1.MIN_HOLD_DAYS -- 持有最小天数
    ,P1.MAX_HOLD_DAYS -- 持有最大天数
    ,P1.MIN_HOLD_AMT -- 持有最小金额
    ,P1.MAX_HOLD_AMT -- 持有最大金额
    ,P1.CLIENT_RATIO -- 客户收益率
    ,P1.BANK_RATIO -- 银行收益率
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ifms_tbpriceset' -- 源表名称
    ,'ifmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ifms_tbpriceset p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.CLIENT_TYPE = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'IFMS'
        AND R1.SRC_TAB_EN_NAME= 'IFMS_TBPRICESET'
        AND R1.SRC_FIELD_EN_NAME= 'CLIENT_TYPE'
        AND R1.TARGET_TAB_EN_NAME= 'REF_FINC_PROD_YLD_RAT_SET'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'CUST_TYPE_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;



whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.ref_finc_prod_yld_rat_set_ifmsf1_tm 
  	                                group by 
  	                                        flow_num
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
insert /*+ append */ into ${iml_schema}.ref_finc_prod_yld_rat_set_ifmsf1_ex(
    flow_num -- 流水号
    ,lp_id -- 法人编号
    ,prod_id -- 产品编号
    ,vp -- 有效期
    ,prft_mode_cd -- 收益模式代码
    ,seller_cd -- 销售商代码
    ,cust_type_cd -- 客户类型代码
    ,sell_type_cd -- 销售类型代码
    ,hold_days -- 持有天数
    ,hold_min_days -- 持有最小天数
    ,hold_max_days -- 持有最大天数
    ,hold_min_amt -- 持有最小金额
    ,hold_max_amt -- 持有最大金额
    ,cust_yld_rat -- 客户收益率
    ,bank_yld_rat -- 银行收益率
    ,create_dt -- 创建日期
    ,update_dt -- 更新日期
    ,etl_dt -- ETL处理日期
    ,id_mark -- 增删标志
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    nvl(n.flow_num, o.flow_num) as flow_num -- 流水号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.prod_id, o.prod_id) as prod_id -- 产品编号
    ,nvl(n.vp, o.vp) as vp -- 有效期
    ,nvl(n.prft_mode_cd, o.prft_mode_cd) as prft_mode_cd -- 收益模式代码
    ,nvl(n.seller_cd, o.seller_cd) as seller_cd -- 销售商代码
    ,nvl(n.cust_type_cd, o.cust_type_cd) as cust_type_cd -- 客户类型代码
    ,nvl(n.sell_type_cd, o.sell_type_cd) as sell_type_cd -- 销售类型代码
    ,nvl(n.hold_days, o.hold_days) as hold_days -- 持有天数
    ,nvl(n.hold_min_days, o.hold_min_days) as hold_min_days -- 持有最小天数
    ,nvl(n.hold_max_days, o.hold_max_days) as hold_max_days -- 持有最大天数
    ,nvl(n.hold_min_amt, o.hold_min_amt) as hold_min_amt -- 持有最小金额
    ,nvl(n.hold_max_amt, o.hold_max_amt) as hold_max_amt -- 持有最大金额
    ,nvl(n.cust_yld_rat, o.cust_yld_rat) as cust_yld_rat -- 客户收益率
    ,nvl(n.bank_yld_rat, o.bank_yld_rat) as bank_yld_rat -- 银行收益率
    ,nvl(o.create_dt, to_date('${batch_date}', 'yyyymmdd')) as create_dt -- 创建日期
    ,case when (
                o.flow_num is null
                and o.lp_id is null
            ) or (
                o.prod_id <> n.prod_id
                or o.vp <> n.vp
                or o.prft_mode_cd <> n.prft_mode_cd
                or o.seller_cd <> n.seller_cd
                or o.cust_type_cd <> n.cust_type_cd
                or o.sell_type_cd <> n.sell_type_cd
                or o.hold_days <> n.hold_days
                or o.hold_min_days <> n.hold_min_days
                or o.hold_max_days <> n.hold_max_days
                or o.hold_min_amt <> n.hold_min_amt
                or o.hold_max_amt <> n.hold_max_amt
                or o.cust_yld_rat <> n.cust_yld_rat
                or o.bank_yld_rat <> n.bank_yld_rat
            ) or (
                n.flow_num is null
                and n.lp_id is null
                and o.id_mark='I'
            )
        then to_date('${batch_date}', 'yyyymmdd')
        else o.update_dt
     end as update_dt -- 更新日期
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt -- ETL处理日期
    ,case when (
                n.flow_num is null
                and n.lp_id is null
            )
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ref_finc_prod_yld_rat_set_ifmsf1_tm n
    full join ${iml_schema}.ref_finc_prod_yld_rat_set_ifmsf1_bk o
        on
            o.flow_num = n.flow_num
            and o.lp_id = n.lp_id
;
commit;

-- 3.1 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.ref_finc_prod_yld_rat_set truncate partition for ('ifmsf1') reuse storage;

-- 3.2 exchage tm table and target table
alter table ${iml_schema}.ref_finc_prod_yld_rat_set exchange subpartition p_ifmsf1_${batch_date} with table ${iml_schema}.ref_finc_prod_yld_rat_set_ifmsf1_ex;

-- 3.3 drop subpartition last_date partition
whenever sqlerror continue none ;
alter table ${iml_schema}.ref_finc_prod_yld_rat_set drop subpartition p_ifmsf1_${last_date} ;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.ref_finc_prod_yld_rat_set to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.ref_finc_prod_yld_rat_set_ifmsf1_tm purge;
drop table ${iml_schema}.ref_finc_prod_yld_rat_set_ifmsf1_ex purge;
drop table ${iml_schema}.ref_finc_prod_yld_rat_set_ifmsf1_bk purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'ref_finc_prod_yld_rat_set', partname => 'p_ifmsf1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);