/*
Purpose:    整全模型层-快照表脚本，备份目标表当月数据（不含当天），用前一天数据与当天数据整合后插入到目标表中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_prd_fin_instm_int_rat_makt_ibmsf1
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
drop table ${iml_schema}.prd_fin_instm_int_rat_makt_ibmsf1_tm purge;
drop table ${iml_schema}.prd_fin_instm_int_rat_makt_ibmsf1_ex purge;

-- 2.2 add partition for target table
alter table ${iml_schema}.prd_fin_instm_int_rat_makt add partition p_ibmsf1 values ('ibmsf1')(
        subpartition p_ibmsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.prd_fin_instm_int_rat_makt modify partition p_ibmsf1
    add subpartition p_ibmsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

-- 2.3 if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.prd_fin_instm_int_rat_makt_ibmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.prd_fin_instm_int_rat_makt partition for ('ibmsf1')
where create_dt < to_date('${batch_date}','yyyymmdd')
;

-- 2.4 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.prd_fin_instm_int_rat_makt_ibmsf1_tm
compress ${option_switch} for query high
as
select
    flow_num -- 流水号
    ,lp_id -- 法人编号
    ,fin_instm_id -- 金融工具编号
    ,asset_type_id -- 资产类型编号
    ,market_type_id -- 市场类型编号
    ,close_quot_price -- 收盘价
    ,higt_price -- 最高价
    ,lowt_price -- 最低价
    ,sell_price -- 卖出价
    ,buy_price -- 买入价
    ,mdl_p -- 中间价
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
    ,imp_tm -- 导入时间
    ,imp_way_id -- 导入方式编号
    ,data_src_type -- 数据来源类型
    ,effect_flg -- 生效标志
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.prd_fin_instm_int_rat_makt
where 0=1;

-- 2.5 create temp table
create table ${iml_schema}.prd_fin_instm_int_rat_makt_ibmsf1_ex nologging
compress ${option_switch} for query high
as select * from ${iml_schema}.prd_fin_instm_int_rat_makt partition for ('ibmsf1') where 0=1;

-- 2.1 insert data to tm table
-- ibms_tir_series-1
insert into ${iml_schema}.prd_fin_instm_int_rat_makt_ibmsf1_tm(
    flow_num -- 流水号
    ,lp_id -- 法人编号
    ,fin_instm_id -- 金融工具编号
    ,asset_type_id -- 资产类型编号
    ,market_type_id -- 市场类型编号
    ,close_quot_price -- 收盘价
    ,higt_price -- 最高价
    ,lowt_price -- 最低价
    ,sell_price -- 卖出价
    ,buy_price -- 买入价
    ,mdl_p -- 中间价
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
    ,imp_tm -- 导入时间
    ,imp_way_id -- 导入方式编号
    ,data_src_type -- 数据来源类型
    ,effect_flg -- 生效标志
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.DP_ID -- 流水号
    ,'9999' -- 法人编号
    ,P1.I_CODE -- 金融工具编号
    ,P1.A_TYPE -- 资产类型编号
    ,P1.M_TYPE -- 市场类型编号
    ,P1.DP_CLOSE -- 收盘价
    ,P1.DP_HIGH -- 最高价
    ,P1.DP_LOW -- 最低价
    ,P1.DP_ASK -- 卖出价
    ,P1.DP_BID -- 买入价
    ,P1.DP_MID -- 中间价
    ,P1.BEG_DATE -- 生效日期
    ,P1.END_DATE -- 失效日期
    ,${iml_schema}.DATEFORMAT_MIN(
CASE WHEN LENGTHB(P1.IMP_TIME)=19 THEN P1.IMP_TIME
     WHEN LENGTHB(P1.IMP_TIME)=8  THEN P1.IMP_DATE||' '||P1.IMP_TIME
     ELSE P1.IMP_DATE
     END) -- 导入时间
    ,P1.PIPE_ID -- 导入方式编号
    ,P1.DP_BANK -- 数据来源类型
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.STATE END -- 生效标志
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ibms_tir_series' -- 源表名称
    ,'ibmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ibms_tir_series p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.STATE= R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'IBMS'
        AND R1.SRC_TAB_EN_NAME= 'IBMS_TIR_SERIES'
        AND R1.SRC_FIELD_EN_NAME= 'STATE'
        AND R1.TARGET_TAB_EN_NAME= 'PRD_FIN_INSTM_INT_RAT_MAKT'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'EFFECT_FLG'
where  1 = 1 
;
commit;


commit;



whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.prd_fin_instm_int_rat_makt_ibmsf1_tm 
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
insert /*+ append */ into ${iml_schema}.prd_fin_instm_int_rat_makt_ibmsf1_ex(
    flow_num -- 流水号
    ,lp_id -- 法人编号
    ,fin_instm_id -- 金融工具编号
    ,asset_type_id -- 资产类型编号
    ,market_type_id -- 市场类型编号
    ,close_quot_price -- 收盘价
    ,higt_price -- 最高价
    ,lowt_price -- 最低价
    ,sell_price -- 卖出价
    ,buy_price -- 买入价
    ,mdl_p -- 中间价
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
    ,imp_tm -- 导入时间
    ,imp_way_id -- 导入方式编号
    ,data_src_type -- 数据来源类型
    ,effect_flg -- 生效标志
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
    ,nvl(n.fin_instm_id, o.fin_instm_id) as fin_instm_id -- 金融工具编号
    ,nvl(n.asset_type_id, o.asset_type_id) as asset_type_id -- 资产类型编号
    ,nvl(n.market_type_id, o.market_type_id) as market_type_id -- 市场类型编号
    ,nvl(n.close_quot_price, o.close_quot_price) as close_quot_price -- 收盘价
    ,nvl(n.higt_price, o.higt_price) as higt_price -- 最高价
    ,nvl(n.lowt_price, o.lowt_price) as lowt_price -- 最低价
    ,nvl(n.sell_price, o.sell_price) as sell_price -- 卖出价
    ,nvl(n.buy_price, o.buy_price) as buy_price -- 买入价
    ,nvl(n.mdl_p, o.mdl_p) as mdl_p -- 中间价
    ,nvl(n.effect_dt, o.effect_dt) as effect_dt -- 生效日期
    ,nvl(n.invalid_dt, o.invalid_dt) as invalid_dt -- 失效日期
    ,nvl(n.imp_tm, o.imp_tm) as imp_tm -- 导入时间
    ,nvl(n.imp_way_id, o.imp_way_id) as imp_way_id -- 导入方式编号
    ,nvl(n.data_src_type, o.data_src_type) as data_src_type -- 数据来源类型
    ,nvl(n.effect_flg, o.effect_flg) as effect_flg -- 生效标志
    ,nvl(o.create_dt, to_date('${batch_date}', 'yyyymmdd')) as create_dt -- 创建日期
    ,case when (
                o.flow_num is null
                and o.lp_id is null
            ) or (
                o.fin_instm_id <> n.fin_instm_id
                or o.asset_type_id <> n.asset_type_id
                or o.market_type_id <> n.market_type_id
                or o.close_quot_price <> n.close_quot_price
                or o.higt_price <> n.higt_price
                or o.lowt_price <> n.lowt_price
                or o.sell_price <> n.sell_price
                or o.buy_price <> n.buy_price
                or o.mdl_p <> n.mdl_p
                or o.effect_dt <> n.effect_dt
                or o.invalid_dt <> n.invalid_dt
                or o.imp_tm <> n.imp_tm
                or o.imp_way_id <> n.imp_way_id
                or o.data_src_type <> n.data_src_type
                or o.effect_flg <> n.effect_flg
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
from ${iml_schema}.prd_fin_instm_int_rat_makt_ibmsf1_tm n
    full join ${iml_schema}.prd_fin_instm_int_rat_makt_ibmsf1_bk o
        on
            o.flow_num = n.flow_num
            and o.lp_id = n.lp_id
;
commit;

-- 3.1 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.prd_fin_instm_int_rat_makt truncate partition for ('ibmsf1') reuse storage;

-- 3.2 exchage tm table and target table
alter table ${iml_schema}.prd_fin_instm_int_rat_makt exchange subpartition p_ibmsf1_${batch_date} with table ${iml_schema}.prd_fin_instm_int_rat_makt_ibmsf1_ex;

-- 3.3 drop subpartition last_date partition
whenever sqlerror continue none ;
alter table ${iml_schema}.prd_fin_instm_int_rat_makt drop subpartition p_ibmsf1_${last_date} update global indexes;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.prd_fin_instm_int_rat_makt to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.prd_fin_instm_int_rat_makt_ibmsf1_tm purge;
drop table ${iml_schema}.prd_fin_instm_int_rat_makt_ibmsf1_ex purge;
drop table ${iml_schema}.prd_fin_instm_int_rat_makt_ibmsf1_bk purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'prd_fin_instm_int_rat_makt', partname => 'p_ibmsf1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);