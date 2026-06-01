/*
Purpose:    整全模型层-快照表脚本，备份目标表当月数据（不含当天），用前一天数据与当天数据整合后插入到目标表中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_prd_fund_prft_ibmsf1
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
drop table ${iml_schema}.prd_fund_prft_ibmsf1_tm purge;
drop table ${iml_schema}.prd_fund_prft_ibmsf1_ex purge;

-- 2.2 add partition for target table
alter table ${iml_schema}.prd_fund_prft add partition p_ibmsf1 values ('ibmsf1')(
        subpartition p_ibmsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.prd_fund_prft modify partition p_ibmsf1
    add subpartition p_ibmsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

-- 2.3 if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.prd_fund_prft_ibmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.prd_fund_prft partition for ('ibmsf1')
where create_dt < to_date('${batch_date}','yyyymmdd')
;

-- 2.4 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.prd_fund_prft_ibmsf1_tm
compress ${option_switch} for query high
as
select
    flow_num -- 流水号
    ,lp_id -- 法人编号
    ,fund_id -- 基金编号
    ,asset_type_id -- 资产类型编号
    ,market_type_id -- 市场类型编号
    ,tot_net_price -- 总净价
    ,sevn_aual_yld -- 七日年化收益率
    ,pub_dt -- 公布日期
    ,prft_start_dt -- 收益开始日期
    ,prft_end_dt -- 收益结束日期
    ,imp_tm -- 导入时间
    ,imp_way_id -- 导入方式编号
    ,accu_corp_nv -- 累积单位净值
    ,sevn_ten_thous_prft -- 七日万份收益
    ,corp_nv -- 单位净值
    ,fund_size -- 基金规模
    ,fund_tot_lot -- 基金总份额
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.prd_fund_prft
where 0=1;

-- 2.5 create temp table
create table ${iml_schema}.prd_fund_prft_ibmsf1_ex nologging
compress ${option_switch} for query high
as select * from ${iml_schema}.prd_fund_prft partition for ('ibmsf1') where 0=1;

-- 2.1 insert data to tm table
-- ibms_tfnd_nav-1
insert into ${iml_schema}.prd_fund_prft_ibmsf1_tm(
    flow_num -- 流水号
    ,lp_id -- 法人编号
    ,fund_id -- 基金编号
    ,asset_type_id -- 资产类型编号
    ,market_type_id -- 市场类型编号
    ,tot_net_price -- 总净价
    ,sevn_aual_yld -- 七日年化收益率
    ,pub_dt -- 公布日期
    ,prft_start_dt -- 收益开始日期
    ,prft_end_dt -- 收益结束日期
    ,imp_tm -- 导入时间
    ,imp_way_id -- 导入方式编号
    ,accu_corp_nv -- 累积单位净值
    ,sevn_ten_thous_prft -- 七日万份收益
    ,corp_nv -- 单位净值
    ,fund_size -- 基金规模
    ,fund_tot_lot -- 基金总份额
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    TO_CHAR(P1.F_ID) -- 流水号
    ,'9999' -- 法人编号
    ,P1.I_CODE -- 基金编号
    ,P1.A_TYPE -- 资产类型编号
    ,P1.M_TYPE -- 市场类型编号
    ,P1.F_TOTALNAV -- 总净价
    ,P1.F_YIELD_7D -- 七日年化收益率
    ,${iml_schema}.DATEFORMAT_MIN(P1.F_PUBDATE) -- 公布日期
    ,${iml_schema}.DATEFORMAT_MIN(P1.BEG_DATE) -- 收益开始日期
    ,${iml_schema}.DATEFORMAT_MAX(P1.END_DATE) -- 收益结束日期
    ,${iml_schema}.DATEFORMAT_MIN(P1.IMP_DATE) -- 导入时间
    ,TO_CHAR(P1.PIPE_ID) -- 导入方式编号
    ,NVL(TO_NUMBER(TRIM(P1.F_CUMU_NAV)),0) -- 累积单位净值
    ,P1.F_PROFIT_1W -- 七日万份收益
    ,P1.F_UNITNAV -- 单位净值
    ,P1.F_SCAL -- 基金规模
    ,P1.F_COUNT -- 基金总份额
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ibms_tfnd_nav' -- 源表名称
    ,'ibmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ibms_tfnd_nav p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;



whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.prd_fund_prft_ibmsf1_tm 
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
insert /*+ append */ into ${iml_schema}.prd_fund_prft_ibmsf1_ex(
    flow_num -- 流水号
    ,lp_id -- 法人编号
    ,fund_id -- 基金编号
    ,asset_type_id -- 资产类型编号
    ,market_type_id -- 市场类型编号
    ,tot_net_price -- 总净价
    ,sevn_aual_yld -- 七日年化收益率
    ,pub_dt -- 公布日期
    ,prft_start_dt -- 收益开始日期
    ,prft_end_dt -- 收益结束日期
    ,imp_tm -- 导入时间
    ,imp_way_id -- 导入方式编号
    ,accu_corp_nv -- 累积单位净值
    ,sevn_ten_thous_prft -- 七日万份收益
    ,corp_nv -- 单位净值
    ,fund_size -- 基金规模
    ,fund_tot_lot -- 基金总份额
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
    ,nvl(n.fund_id, o.fund_id) as fund_id -- 基金编号
    ,nvl(n.asset_type_id, o.asset_type_id) as asset_type_id -- 资产类型编号
    ,nvl(n.market_type_id, o.market_type_id) as market_type_id -- 市场类型编号
    ,nvl(n.tot_net_price, o.tot_net_price) as tot_net_price -- 总净价
    ,nvl(n.sevn_aual_yld, o.sevn_aual_yld) as sevn_aual_yld -- 七日年化收益率
    ,nvl(n.pub_dt, o.pub_dt) as pub_dt -- 公布日期
    ,nvl(n.prft_start_dt, o.prft_start_dt) as prft_start_dt -- 收益开始日期
    ,nvl(n.prft_end_dt, o.prft_end_dt) as prft_end_dt -- 收益结束日期
    ,nvl(n.imp_tm, o.imp_tm) as imp_tm -- 导入时间
    ,nvl(n.imp_way_id, o.imp_way_id) as imp_way_id -- 导入方式编号
    ,nvl(n.accu_corp_nv, o.accu_corp_nv) as accu_corp_nv -- 累积单位净值
    ,nvl(n.sevn_ten_thous_prft, o.sevn_ten_thous_prft) as sevn_ten_thous_prft -- 七日万份收益
    ,nvl(n.corp_nv, o.corp_nv) as corp_nv -- 单位净值
    ,nvl(n.fund_size, o.fund_size) as fund_size -- 基金规模
    ,nvl(n.fund_tot_lot, o.fund_tot_lot) as fund_tot_lot -- 基金总份额
    ,nvl(o.create_dt, to_date('${batch_date}', 'yyyymmdd')) as create_dt -- 创建日期
    ,case when (
                o.flow_num is null
                and o.lp_id is null
            ) or (
                o.fund_id <> n.fund_id
                or o.asset_type_id <> n.asset_type_id
                or o.market_type_id <> n.market_type_id
                or o.tot_net_price <> n.tot_net_price
                or o.sevn_aual_yld <> n.sevn_aual_yld
                or o.pub_dt <> n.pub_dt
                or o.prft_start_dt <> n.prft_start_dt
                or o.prft_end_dt <> n.prft_end_dt
                or o.imp_tm <> n.imp_tm
                or o.imp_way_id <> n.imp_way_id
                or o.accu_corp_nv <> n.accu_corp_nv
                or o.sevn_ten_thous_prft <> n.sevn_ten_thous_prft
                or o.corp_nv <> n.corp_nv
                or o.fund_size <> n.fund_size
                or o.fund_tot_lot <> n.fund_tot_lot
            ) or (
                 case when (
                           n.flow_num is null
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
                n.flow_num is null
                and n.lp_id is null
            )
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.prd_fund_prft_ibmsf1_tm n
    full join ${iml_schema}.prd_fund_prft_ibmsf1_bk o
        on
            o.flow_num = n.flow_num
            and o.lp_id = n.lp_id
;
commit;

-- 3.1 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.prd_fund_prft truncate partition for ('ibmsf1') reuse storage;

-- 3.2 exchage tm table and target table
alter table ${iml_schema}.prd_fund_prft exchange subpartition p_ibmsf1_${batch_date} with table ${iml_schema}.prd_fund_prft_ibmsf1_ex;

-- 3.3 drop subpartition last_date partition
whenever sqlerror continue none ;
alter table ${iml_schema}.prd_fund_prft drop subpartition p_ibmsf1_${last_date} update global indexes;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.prd_fund_prft to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.prd_fund_prft_ibmsf1_tm purge;
drop table ${iml_schema}.prd_fund_prft_ibmsf1_ex purge;
drop table ${iml_schema}.prd_fund_prft_ibmsf1_bk purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'prd_fund_prft', partname => 'p_ibmsf1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);