/*
Purpose:    整全模型层-快照表脚本，备份目标表当月数据（不含当天），用前一天数据与当天数据整合后插入到目标表中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_prd_insure_prod_inssf1
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
drop table ${iml_schema}.prd_insure_prod_inssf1_tm purge;
drop table ${iml_schema}.prd_insure_prod_inssf1_ex purge;

-- 2.2 add partition for target table
alter table ${iml_schema}.prd_insure_prod add partition p_inssf1 values ('inssf1')(
        subpartition p_inssf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.prd_insure_prod modify partition p_inssf1
    add subpartition p_inssf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

-- 2.3 if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.prd_insure_prod_inssf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.prd_insure_prod partition for ('inssf1')
where create_dt < to_date('${batch_date}','yyyymmdd')
;

-- 2.4 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.prd_insure_prod_inssf1_tm
compress ${option_switch} for query high
as
select
    prod_id -- 产品编号
    ,lp_id -- 法人编号
    ,ta_cd -- TA代码
    ,std_prod_id -- 标准产品编号
    ,prod_name -- 产品名称
    ,prod_descb -- 产品描述
    ,prod_type_cd -- 产品类型代码
    ,prod_sub_type_cd -- 产品子类型代码
    ,commer_insure_flg -- 商业保险标志
    ,lmt_ctrl_type_cd -- 额度控制类型代码
    ,curr_cd -- 币种代码
    ,onl_flg -- 线上标志
    ,prod_effect_dt -- 产品生效日期
    ,prod_invalid_dt -- 产品失效日期
    ,add_flg -- 增加标志
    ,dir_insure_prod_id -- 定向保险产品编号
    ,reptac_days -- 反悔天数
    ,ctrl_flg_comb -- 控制标志组合
    ,risk_level_cd -- 风险等级代码
    ,resv_1 -- 备用1
    ,resv_2 -- 备用2
    ,resv_3 -- 备用3
    ,resv_4 -- 备用4
    ,indv_min_permium_amt -- 个人最小保费金额
    ,org_min_permium_amt -- 机构最小保费金额
    ,indv_max_permium_amt -- 个人最大保费金额
    ,org_max_permium_amt -- 机构最大保费金额
    ,indv_min_permium_corp -- 个人最小保费单位
    ,org_min_permium_corp -- 机构最小保费单位
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.prd_insure_prod
where 0=1;

-- 2.5 create temp table
create table ${iml_schema}.prd_insure_prod_inssf1_ex nologging
compress ${option_switch} for query high
as select * from ${iml_schema}.prd_insure_prod partition for ('inssf1') where 0=1;

-- 2.1 insert data to tm table
-- ifms_tbinsureproduct-
insert into ${iml_schema}.prd_insure_prod_inssf1_tm(
    prod_id -- 产品编号
    ,lp_id -- 法人编号
    ,ta_cd -- TA代码
    ,std_prod_id -- 标准产品编号
    ,prod_name -- 产品名称
    ,prod_descb -- 产品描述
    ,prod_type_cd -- 产品类型代码
    ,prod_sub_type_cd -- 产品子类型代码
    ,commer_insure_flg -- 商业保险标志
    ,lmt_ctrl_type_cd -- 额度控制类型代码
    ,curr_cd -- 币种代码
    ,onl_flg -- 线上标志
    ,prod_effect_dt -- 产品生效日期
    ,prod_invalid_dt -- 产品失效日期
    ,add_flg -- 增加标志
    ,dir_insure_prod_id -- 定向保险产品编号
    ,reptac_days -- 反悔天数
    ,ctrl_flg_comb -- 控制标志组合
    ,risk_level_cd -- 风险等级代码
    ,resv_1 -- 备用1
    ,resv_2 -- 备用2
    ,resv_3 -- 备用3
    ,resv_4 -- 备用4
    ,indv_min_permium_amt -- 个人最小保费金额
    ,org_min_permium_amt -- 机构最小保费金额
    ,indv_max_permium_amt -- 个人最大保费金额
    ,org_max_permium_amt -- 机构最大保费金额
    ,indv_min_permium_corp -- 个人最小保费单位
    ,org_min_permium_corp -- 机构最小保费单位
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    p1.PRD_CODE -- 产品编号
    ,'9999' -- 法人编号
    ,p1.TA_CODE -- TA代码
    ,case
         when substr(p1.control_flag, 9, 1) = '1' then
          '602020300001'
         when substr(p1.control_flag, 9, 1) = '2' then
          '602020300004'
         when substr(p1.control_flag, 9, 1) = '3' then
          '602020300003'
         when substr(p1.control_flag, 9, 1) = '4' then
          '602020300002'
         when p1.prd_sub_type in ('1', '2', '3') then
          '602020300005'
         else
          '-'
       end -- 标准产品编号
    ,p1.PRD_NAME -- 产品名称
    ,p1.PRD_NAME2 -- 产品描述
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||P1.PRD_TYPE END -- 产品类型代码
    ,NVL(TRIM(p1.PRD_SUB_TYPE),'-') -- 产品子类型代码
    ,NVL(TRIM(p1.PRD_BUSIN_FLAG),'-') -- 商业保险标志
    ,NVL(TRIM(p1.PRD_LIMIT_FLAG),'-') -- 额度控制类型代码
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.CURR_TYPE END -- 币种代码
    ,NVL(TRIM(p1.ONLINE_FLAG),'-') -- 线上标志
    ,${iml_schema}.dateformat_min(to_char(P1.BEGIN_DATE)) -- 产品生效日期
    ,${iml_schema}.dateformat_max(to_char(P1.END_DATE)) -- 产品失效日期
    ,NVL(TRIM(p1.PRD_ADD_FLAG),'-') -- 增加标志
    ,p1.TARG_PRD_CODE -- 定向保险产品编号
    ,p1.WAVER_DAYS -- 反悔天数
    ,p1.CONTROL_FLAG -- 控制标志组合
    ,CASE WHEN R4.TARGET_CD_VAL IS NOT NULL THEN R4.TARGET_CD_VAL ELSE '@'||substr(P1.RESERVE2,1,1) END -- 风险等级代码
    ,P1.RESERVE1 -- 备用1
    ,P1.RESERVE2 -- 备用2
    ,P1.RESERVE3 -- 备用3
    ,P1.RESERVE4 -- 备用4
    ,P1.PMIN_AMT -- 个人最小保费金额
    ,P1.OMIN_AMT -- 机构最小保费金额
    ,P1.PMAX_AMT -- 个人最大保费金额
    ,P1.OMAX_AMT -- 机构最大保费金额
    ,P1.PUNIT_AMT -- 个人最小保费单位
    ,P1.OUNIT_AMT -- 机构最小保费单位
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ifms_tbinsureproduct' -- 源表名称
    ,'inssf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ifms_tbinsureproduct p1
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.PRD_TYPE= R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'IFMS'
        AND R2.SRC_TAB_EN_NAME= 'IFMS_TBINSUREPRODUCT'
        AND R2.SRC_FIELD_EN_NAME= 'PRD_TYPE'
        AND R2.TARGET_TAB_EN_NAME= 'PRD_INSURE_PROD'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'PROD_TYPE_CD'
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.CURR_TYPE= R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'IFMS'
        AND R1.SRC_TAB_EN_NAME= 'IFMS_TBINSUREPRODUCT'
        AND R1.SRC_FIELD_EN_NAME= 'CURR_TYPE'
        AND R1.TARGET_TAB_EN_NAME= 'PRD_INSURE_PROD'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'CURR_CD'
    left join ${iml_schema}.ref_pub_cd_map r4 on substr(P1.RESERVE2,1,1)= R4.SRC_CODE_VAL
        AND R4.SORC_SYS_CD= 'IFMS'
        AND R4.SRC_TAB_EN_NAME= 'IFMS_TBINSUREPRODUCT'
        AND R4.SRC_FIELD_EN_NAME= 'RESERVE2'
        AND R4.TARGET_TAB_EN_NAME= 'PRD_INSURE_PROD'
        AND R4.TARGET_TAB_FIELD_EN_NAME= 'RISK_LEVEL_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;



whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.prd_insure_prod_inssf1_tm 
  	                                group by 
  	                                        prod_id
  	                                        ,lp_id
  	                                        ,ta_cd
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
insert /*+ append */ into ${iml_schema}.prd_insure_prod_inssf1_ex(
    prod_id -- 产品编号
    ,lp_id -- 法人编号
    ,ta_cd -- TA代码
    ,std_prod_id -- 标准产品编号
    ,prod_name -- 产品名称
    ,prod_descb -- 产品描述
    ,prod_type_cd -- 产品类型代码
    ,prod_sub_type_cd -- 产品子类型代码
    ,commer_insure_flg -- 商业保险标志
    ,lmt_ctrl_type_cd -- 额度控制类型代码
    ,curr_cd -- 币种代码
    ,onl_flg -- 线上标志
    ,prod_effect_dt -- 产品生效日期
    ,prod_invalid_dt -- 产品失效日期
    ,add_flg -- 增加标志
    ,dir_insure_prod_id -- 定向保险产品编号
    ,reptac_days -- 反悔天数
    ,ctrl_flg_comb -- 控制标志组合
    ,risk_level_cd -- 风险等级代码
    ,resv_1 -- 备用1
    ,resv_2 -- 备用2
    ,resv_3 -- 备用3
    ,resv_4 -- 备用4
    ,indv_min_permium_amt -- 个人最小保费金额
    ,org_min_permium_amt -- 机构最小保费金额
    ,indv_max_permium_amt -- 个人最大保费金额
    ,org_max_permium_amt -- 机构最大保费金额
    ,indv_min_permium_corp -- 个人最小保费单位
    ,org_min_permium_corp -- 机构最小保费单位
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
    ,nvl(n.ta_cd, o.ta_cd) as ta_cd -- TA代码
    ,nvl(n.std_prod_id, o.std_prod_id) as std_prod_id -- 标准产品编号
    ,nvl(n.prod_name, o.prod_name) as prod_name -- 产品名称
    ,nvl(n.prod_descb, o.prod_descb) as prod_descb -- 产品描述
    ,nvl(n.prod_type_cd, o.prod_type_cd) as prod_type_cd -- 产品类型代码
    ,nvl(n.prod_sub_type_cd, o.prod_sub_type_cd) as prod_sub_type_cd -- 产品子类型代码
    ,nvl(n.commer_insure_flg, o.commer_insure_flg) as commer_insure_flg -- 商业保险标志
    ,nvl(n.lmt_ctrl_type_cd, o.lmt_ctrl_type_cd) as lmt_ctrl_type_cd -- 额度控制类型代码
    ,nvl(n.curr_cd, o.curr_cd) as curr_cd -- 币种代码
    ,nvl(n.onl_flg, o.onl_flg) as onl_flg -- 线上标志
    ,nvl(n.prod_effect_dt, o.prod_effect_dt) as prod_effect_dt -- 产品生效日期
    ,nvl(n.prod_invalid_dt, o.prod_invalid_dt) as prod_invalid_dt -- 产品失效日期
    ,nvl(n.add_flg, o.add_flg) as add_flg -- 增加标志
    ,nvl(n.dir_insure_prod_id, o.dir_insure_prod_id) as dir_insure_prod_id -- 定向保险产品编号
    ,nvl(n.reptac_days, o.reptac_days) as reptac_days -- 反悔天数
    ,nvl(n.ctrl_flg_comb, o.ctrl_flg_comb) as ctrl_flg_comb -- 控制标志组合
    ,nvl(n.risk_level_cd, o.risk_level_cd) as risk_level_cd -- 风险等级代码
    ,nvl(n.resv_1, o.resv_1) as resv_1 -- 备用1
    ,nvl(n.resv_2, o.resv_2) as resv_2 -- 备用2
    ,nvl(n.resv_3, o.resv_3) as resv_3 -- 备用3
    ,nvl(n.resv_4, o.resv_4) as resv_4 -- 备用4
    ,nvl(n.indv_min_permium_amt, o.indv_min_permium_amt) as indv_min_permium_amt -- 个人最小保费金额
    ,nvl(n.org_min_permium_amt, o.org_min_permium_amt) as org_min_permium_amt -- 机构最小保费金额
    ,nvl(n.indv_max_permium_amt, o.indv_max_permium_amt) as indv_max_permium_amt -- 个人最大保费金额
    ,nvl(n.org_max_permium_amt, o.org_max_permium_amt) as org_max_permium_amt -- 机构最大保费金额
    ,nvl(n.indv_min_permium_corp, o.indv_min_permium_corp) as indv_min_permium_corp -- 个人最小保费单位
    ,nvl(n.org_min_permium_corp, o.org_min_permium_corp) as org_min_permium_corp -- 机构最小保费单位
    ,nvl(o.create_dt, to_date('${batch_date}', 'yyyymmdd')) as create_dt -- 创建日期
    ,case when (
                o.prod_id is null
                and o.lp_id is null
                and o.ta_cd is null
            ) or (
                o.std_prod_id <> n.std_prod_id
                or o.prod_name <> n.prod_name
                or o.prod_descb <> n.prod_descb
                or o.prod_type_cd <> n.prod_type_cd
                or o.prod_sub_type_cd <> n.prod_sub_type_cd
                or o.commer_insure_flg <> n.commer_insure_flg
                or o.lmt_ctrl_type_cd <> n.lmt_ctrl_type_cd
                or o.curr_cd <> n.curr_cd
                or o.onl_flg <> n.onl_flg
                or o.prod_effect_dt <> n.prod_effect_dt
                or o.prod_invalid_dt <> n.prod_invalid_dt
                or o.add_flg <> n.add_flg
                or o.dir_insure_prod_id <> n.dir_insure_prod_id
                or o.reptac_days <> n.reptac_days
                or o.ctrl_flg_comb <> n.ctrl_flg_comb
                or o.risk_level_cd <> n.risk_level_cd
                or o.resv_1 <> n.resv_1
                or o.resv_2 <> n.resv_2
                or o.resv_3 <> n.resv_3
                or o.resv_4 <> n.resv_4
                or o.indv_min_permium_amt <> n.indv_min_permium_amt
                or o.org_min_permium_amt <> n.org_min_permium_amt
                or o.indv_max_permium_amt <> n.indv_max_permium_amt
                or o.org_max_permium_amt <> n.org_max_permium_amt
                or o.indv_min_permium_corp <> n.indv_min_permium_corp
                or o.org_min_permium_corp <> n.org_min_permium_corp
            ) or (
                 case when (
                           n.prod_id is null
                           and n.lp_id is null
                           and n.ta_cd is null
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
                and n.ta_cd is null
            )
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.prd_insure_prod_inssf1_tm n
    full join ${iml_schema}.prd_insure_prod_inssf1_bk o
        on
            o.prod_id = n.prod_id
            and o.lp_id = n.lp_id
            and o.ta_cd = n.ta_cd
;
commit;

-- 3.1 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.prd_insure_prod truncate partition for ('inssf1') reuse storage;

-- 3.2 exchage tm table and target table
alter table ${iml_schema}.prd_insure_prod exchange subpartition p_inssf1_${batch_date} with table ${iml_schema}.prd_insure_prod_inssf1_ex;

-- 3.3 drop subpartition last_date partition
whenever sqlerror continue none ;
alter table ${iml_schema}.prd_insure_prod drop subpartition p_inssf1_${last_date} update global indexes;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.prd_insure_prod to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.prd_insure_prod_inssf1_tm purge;
drop table ${iml_schema}.prd_insure_prod_inssf1_ex purge;
drop table ${iml_schema}.prd_insure_prod_inssf1_bk purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'prd_insure_prod', partname => 'p_inssf1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);