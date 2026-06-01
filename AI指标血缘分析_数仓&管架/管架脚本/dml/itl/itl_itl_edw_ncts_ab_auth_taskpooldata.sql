/*
Purpose:    技术缓冲层脚本，把数据文件加载到目标表的当天分区中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd itl_itl_edw_ncts_ab_auth_taskpooldata
CreateDate: 20180515
Logs:
    luzd 2019-05-27 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;


-- 2.1 drop timeout partition and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none;
alter table ${itl_schema}.itl_edw_ncts_ab_auth_taskpooldata drop partition p_${retain_day};
alter table ${itl_schema}.itl_edw_ncts_ab_auth_taskpooldata drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${itl_schema}.itl_edw_ncts_ab_auth_taskpooldata add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${itl_schema}.itl_edw_ncts_ab_auth_taskpooldata partition for (to_date('${batch_date}','yyyymmdd')) (
    authdate -- 授权日期
    ,authserno -- 授权流水
    ,authorgno -- 授权机构
    ,taskpoolid -- 任务池
    ,authlevel -- 授权级别
    ,entrytime -- 进入任务池时间
    ,outtime -- 取出任务池时间
    ,waittime -- 任务排队时间
    ,status -- 任务状态;0,未获取;1,获取
    ,authtellerno -- 授权柜员
    ,weight -- 权重值
    ,aboid -- 客户端ID
    ,tradeid -- 交易ID
    ,tradeserno -- 交易流水号
    ,flag -- 详细任务标志：0-退件；1-拒绝;2-后补件退件
    ,queuenum -- 
    ,trademode -- 交易模式（1-单交易模式，2-交易包模式）
    ,cartorder -- 购物车授权任务顺序，从1开始
    ,makeupsn -- 购物车组合流水
    ,times -- 提交购物车批次数（跟购物车组合流水一起，唯一标示每一批购物车交易）
    ,replenish_status -- 补件状态
    ,bj_tellerno -- 补件人员
    ,fqbj_tellerno -- 发起后补件人员
    ,bj_authtellerno -- 后补件授权柜员
    ,fqbj_date -- 发起补件日期
    ,fqbj_time -- 发起补件时间
    ,bj_authdate -- 补件授权日期
    ,bj_authtime -- 补件授权时间
    ,bj_successtime -- 补件成功时间
    ,bj_lastoptdate -- 补件任务最新操作日期
    ,replenishflag -- 补件标记。1-后补件;0-默认值，原授权任务，非后补件
    ,start_dt -- 开始时间
    ,end_dt -- 结束时间
    ,id_mark -- 增删标志
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间
)
select
    nvl(trim(authdate), ' ') as authdate -- 授权日期
    ,nvl(trim(authserno), ' ') as authserno -- 授权流水
    ,nvl(trim(authorgno), ' ') as authorgno -- 授权机构
    ,nvl(trim(taskpoolid), ' ') as taskpoolid -- 任务池
    ,nvl(trim(authlevel), ' ') as authlevel -- 授权级别
    ,nvl(trim(entrytime), ' ') as entrytime -- 进入任务池时间
    ,nvl(trim(outtime), ' ') as outtime -- 取出任务池时间
    ,nvl(trim(waittime), 0) as waittime -- 任务排队时间
    ,nvl(trim(status), ' ') as status -- 任务状态;0,未获取;1,获取
    ,nvl(trim(authtellerno), ' ') as authtellerno -- 授权柜员
    ,nvl(trim(weight), 0) as weight -- 权重值
    ,nvl(trim(aboid), ' ') as aboid -- 客户端ID
    ,nvl(trim(tradeid), ' ') as tradeid -- 交易ID
    ,nvl(trim(tradeserno), ' ') as tradeserno -- 交易流水号
    ,nvl(trim(flag), ' ') as flag -- 详细任务标志：0-退件；1-拒绝;2-后补件退件
    ,nvl(trim(queuenum), ' ') as queuenum -- 
    ,nvl(trim(trademode), ' ') as trademode -- 交易模式（1-单交易模式，2-交易包模式）
    ,nvl(trim(cartorder), 0) as cartorder -- 购物车授权任务顺序，从1开始
    ,nvl(trim(makeupsn), ' ') as makeupsn -- 购物车组合流水
    ,nvl(trim(times), 0) as times -- 提交购物车批次数（跟购物车组合流水一起，唯一标示每一批购物车交易）
    ,nvl(trim(replenish_status), ' ') as replenish_status -- 补件状态
    ,nvl(trim(bj_tellerno), ' ') as bj_tellerno -- 补件人员
    ,nvl(trim(fqbj_tellerno), ' ') as fqbj_tellerno -- 发起后补件人员
    ,nvl(trim(bj_authtellerno), ' ') as bj_authtellerno -- 后补件授权柜员
    ,nvl(trim(fqbj_date), ' ') as fqbj_date -- 发起补件日期
    ,nvl(trim(fqbj_time), ' ') as fqbj_time -- 发起补件时间
    ,nvl(trim(bj_authdate), ' ') as bj_authdate -- 补件授权日期
    ,nvl(trim(bj_authtime), ' ') as bj_authtime -- 补件授权时间
    ,nvl(trim(bj_successtime), ' ') as bj_successtime -- 补件成功时间
    ,nvl(trim(bj_lastoptdate), ' ') as bj_lastoptdate -- 补件任务最新操作日期
    ,nvl(trim(replenishflag), ' ') as replenishflag -- 补件标记。1-后补件;0-默认值，原授权任务，非后补件
    ,nvl(start_dt, to_date('00010101', 'yyyymmdd')) as start_dt -- 开始时间
    ,nvl(end_dt, to_date('00010101', 'yyyymmdd')) as end_dt -- 结束时间
    ,nvl(trim(id_mark), ' ') as id_mark -- 增删标志
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${msl_schema}.msl_edw_ncts_ab_auth_taskpooldata
where 1 = 1
 ;
commit;

-- 3 table grant
whenever sqlerror exit sql.sqlcode;
grant select on ${itl_schema}.itl_edw_ncts_ab_auth_taskpooldata to ${idl_schema};

-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${itl_schema}',tabname => 'itl_edw_ncts_ab_auth_taskpooldata',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);