/*
Purpose:    整全模型层-快照表脚本，备份目标表当月数据（不含当天），用前一天数据与当天数据整合后插入到目标表中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_prd_ym_fund_nv_info_mpcsf1
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
drop table ${iml_schema}.prd_ym_fund_nv_info_mpcsf1_tm purge;
drop table ${iml_schema}.prd_ym_fund_nv_info_mpcsf1_ex purge;

-- 2.2 add partition for target table
alter table ${iml_schema}.prd_ym_fund_nv_info add partition p_mpcsf1 values ('mpcsf1')(
        subpartition p_mpcsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.prd_ym_fund_nv_info modify partition p_mpcsf1
    add subpartition p_mpcsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

-- 2.3 if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.prd_ym_fund_nv_info_mpcsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.prd_ym_fund_nv_info partition for ('mpcsf1')
where create_dt < to_date('${batch_date}','yyyymmdd')
;

-- 2.4 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.prd_ym_fund_nv_info_mpcsf1_tm
compress ${option_switch} for query high
as
select
    prod_id -- 产品编号
    ,lp_id -- 法人编号
    ,nv_dt -- 净值日期
    ,fund_cd -- 基金代码
    ,serv_plat_abbr -- 服务平台简称
    ,mercht_id -- 商户编号
    ,corp_nv -- 单位净值
    ,acm_nv -- 累计净值
    ,daily_incr -- 每日涨幅
    ,ten_thous_prft -- 万份收益
    ,sevn_aual_yld -- 七日年化收益率
    ,status_dt -- 状态日期
    ,fund_status_cd -- 基金状态代码
    ,fund_tran_status_cd -- 基金转换状态代码
    ,aip_status_cd -- 定投状态代码
    ,update_tm -- 更新时间
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.prd_ym_fund_nv_info
where 0=1;

-- 2.5 create temp table
create table ${iml_schema}.prd_ym_fund_nv_info_mpcsf1_ex nologging
compress ${option_switch} for query high
as select * from ${iml_schema}.prd_ym_fund_nv_info partition for ('mpcsf1') where 0=1;

-- 2.1 insert data to tm table
-- mpcs_a92fundmarket-
insert into ${iml_schema}.prd_ym_fund_nv_info_mpcsf1_tm(
    prod_id -- 产品编号
    ,lp_id -- 法人编号
    ,nv_dt -- 净值日期
    ,fund_cd -- 基金代码
    ,serv_plat_abbr -- 服务平台简称
    ,mercht_id -- 商户编号
    ,corp_nv -- 单位净值
    ,acm_nv -- 累计净值
    ,daily_incr -- 每日涨幅
    ,ten_thous_prft -- 万份收益
    ,sevn_aual_yld -- 七日年化收益率
    ,status_dt -- 状态日期
    ,fund_status_cd -- 基金状态代码
    ,fund_tran_status_cd -- 基金转换状态代码
    ,aip_status_cd -- 定投状态代码
    ,update_tm -- 更新时间
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '223007'||P1.FUNDCODE -- 产品编号
    ,'9999' -- 法人编号
    ,${iml_schema}.dateformat_max(P1.NAVDATE) -- 净值日期
    ,P1.FUNDCODE -- 基金代码
    ,P1.PAYSYS -- 服务平台简称
    ,P1.INSTID -- 商户编号
    ,P1.NAV -- 单位净值
    ,P1.ACCUMULATEDNAV -- 累计净值
    ,P1.RETURNDAY -- 每日涨幅
    ,P1.UNITYIELD -- 万份收益
    ,P1.YEARLYROE -- 七日年化收益率
    ,${iml_schema}.dateformat_max(P1.STATUSDATE) -- 状态日期
    ,CASE WHEN R3.TARGET_CD_VAL IS NOT NULL THEN R3.TARGET_CD_VAL ELSE '@'||P1.FUNDSTATUS END -- 基金状态代码
    ,nvl(trim(P1.CONVERTSTATUS),'-') -- 基金转换状态代码
    ,CASE WHEN R4.TARGET_CD_VAL IS NOT NULL THEN R4.TARGET_CD_VAL ELSE '@'||P1.INVESTPLANSTATUS END -- 定投状态代码
    ,${iml_schema}.timeformat_max(substr(P1.UPTDATETIME,1,14)||'.'||substr(P1.UPTDATETIME,15,3)) -- 更新时间
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'mpcs_a92fundmarket' -- 源表名称
    ,'mpcsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.mpcs_a92fundmarket p1
    left join ${iml_schema}.ref_pub_cd_map r3 on P1.FUNDSTATUS = R3.SRC_CODE_VAL
        AND R3.SORC_SYS_CD= 'MPCS'
        AND R3.SRC_TAB_EN_NAME= 'MPCS_A92FUNDMARKET'
        AND R3.SRC_FIELD_EN_NAME= 'FUNDSTATUS'
        AND R3.TARGET_TAB_EN_NAME= 'PRD_YM_FUND_NV_INFO'
        AND R3.TARGET_TAB_FIELD_EN_NAME= 'FUND_STATUS_CD'
    left join ${iml_schema}.ref_pub_cd_map r4 on P1.INVESTPLANSTATUS = R4.SRC_CODE_VAL
        AND R4.SORC_SYS_CD= 'MPCS'
        AND R4.SRC_TAB_EN_NAME= 'MPCS_A92FUNDMARKET'
        AND R4.SRC_FIELD_EN_NAME= 'INVESTPLANSTATUS'
        AND R4.TARGET_TAB_EN_NAME= 'PRD_YM_FUND_NV_INFO'
        AND R4.TARGET_TAB_FIELD_EN_NAME= 'AIP_STATUS_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;



whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.prd_ym_fund_nv_info_mpcsf1_tm 
  	                                group by 
  	                                        prod_id
  	                                        ,lp_id
  	                                        ,nv_dt
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
insert /*+ append */ into ${iml_schema}.prd_ym_fund_nv_info_mpcsf1_ex(
    prod_id -- 产品编号
    ,lp_id -- 法人编号
    ,nv_dt -- 净值日期
    ,fund_cd -- 基金代码
    ,serv_plat_abbr -- 服务平台简称
    ,mercht_id -- 商户编号
    ,corp_nv -- 单位净值
    ,acm_nv -- 累计净值
    ,daily_incr -- 每日涨幅
    ,ten_thous_prft -- 万份收益
    ,sevn_aual_yld -- 七日年化收益率
    ,status_dt -- 状态日期
    ,fund_status_cd -- 基金状态代码
    ,fund_tran_status_cd -- 基金转换状态代码
    ,aip_status_cd -- 定投状态代码
    ,update_tm -- 更新时间
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
    ,nvl(n.nv_dt, o.nv_dt) as nv_dt -- 净值日期
    ,nvl(n.fund_cd, o.fund_cd) as fund_cd -- 基金代码
    ,nvl(n.serv_plat_abbr, o.serv_plat_abbr) as serv_plat_abbr -- 服务平台简称
    ,nvl(n.mercht_id, o.mercht_id) as mercht_id -- 商户编号
    ,nvl(n.corp_nv, o.corp_nv) as corp_nv -- 单位净值
    ,nvl(n.acm_nv, o.acm_nv) as acm_nv -- 累计净值
    ,nvl(n.daily_incr, o.daily_incr) as daily_incr -- 每日涨幅
    ,nvl(n.ten_thous_prft, o.ten_thous_prft) as ten_thous_prft -- 万份收益
    ,nvl(n.sevn_aual_yld, o.sevn_aual_yld) as sevn_aual_yld -- 七日年化收益率
    ,nvl(n.status_dt, o.status_dt) as status_dt -- 状态日期
    ,nvl(n.fund_status_cd, o.fund_status_cd) as fund_status_cd -- 基金状态代码
    ,nvl(n.fund_tran_status_cd, o.fund_tran_status_cd) as fund_tran_status_cd -- 基金转换状态代码
    ,nvl(n.aip_status_cd, o.aip_status_cd) as aip_status_cd -- 定投状态代码
    ,nvl(n.update_tm, o.update_tm) as update_tm -- 更新时间
    ,nvl(o.create_dt, to_date('${batch_date}', 'yyyymmdd')) as create_dt -- 创建日期
    ,case when (
                o.prod_id is null
                and o.lp_id is null
                and o.nv_dt is null
            ) or (
                o.fund_cd <> n.fund_cd
                or o.serv_plat_abbr <> n.serv_plat_abbr
                or o.mercht_id <> n.mercht_id
                or o.corp_nv <> n.corp_nv
                or o.acm_nv <> n.acm_nv
                or o.daily_incr <> n.daily_incr
                or o.ten_thous_prft <> n.ten_thous_prft
                or o.sevn_aual_yld <> n.sevn_aual_yld
                or o.status_dt <> n.status_dt
                or o.fund_status_cd <> n.fund_status_cd
                or o.fund_tran_status_cd <> n.fund_tran_status_cd
                or o.aip_status_cd <> n.aip_status_cd
                or o.update_tm <> n.update_tm
            ) or (
                 case when (
                           n.prod_id is null
                           and n.lp_id is null
                           and n.nv_dt is null
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
                and n.nv_dt is null
            )
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.prd_ym_fund_nv_info_mpcsf1_tm n
    full join ${iml_schema}.prd_ym_fund_nv_info_mpcsf1_bk o
        on
            o.prod_id = n.prod_id
            and o.lp_id = n.lp_id
            and o.nv_dt = n.nv_dt
;
commit;

-- 3.1 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.prd_ym_fund_nv_info truncate partition for ('mpcsf1') reuse storage;

-- 3.2 exchage tm table and target table
alter table ${iml_schema}.prd_ym_fund_nv_info exchange subpartition p_mpcsf1_${batch_date} with table ${iml_schema}.prd_ym_fund_nv_info_mpcsf1_ex;

-- 3.3 drop subpartition last_date partition
whenever sqlerror continue none ;
alter table ${iml_schema}.prd_ym_fund_nv_info drop subpartition p_mpcsf1_${last_date} update global indexes;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.prd_ym_fund_nv_info to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.prd_ym_fund_nv_info_mpcsf1_tm purge;
drop table ${iml_schema}.prd_ym_fund_nv_info_mpcsf1_ex purge;
drop table ${iml_schema}.prd_ym_fund_nv_info_mpcsf1_bk purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'prd_ym_fund_nv_info', partname => 'p_mpcsf1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);