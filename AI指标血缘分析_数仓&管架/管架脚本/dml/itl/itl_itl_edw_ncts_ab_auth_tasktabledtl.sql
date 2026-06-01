/*
Purpose:    技术缓冲层脚本，把数据文件加载到目标表的当天分区中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd itl_itl_edw_ncts_ab_auth_tasktabledtl
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
alter table ${itl_schema}.itl_edw_ncts_ab_auth_tasktabledtl drop partition p_${retain_day};
alter table ${itl_schema}.itl_edw_ncts_ab_auth_tasktabledtl drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${itl_schema}.itl_edw_ncts_ab_auth_tasktabledtl add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${itl_schema}.itl_edw_ncts_ab_auth_tasktabledtl partition for (to_date('${batch_date}','yyyymmdd')) (
    txdate -- 交易日期
    ,txtime -- 交易时间
    ,tradeserno -- 前台交易流水号
    ,authserno -- 授权流水号（编号规则：6位日期+10位顺序号）
    ,crtdate -- 创建日期
    ,txorgno -- 交易机构号
    ,txtellerno -- 交易柜员号
    ,authorgno -- 授权机构号
    ,authtellerno -- 授权柜员号
    ,auditorgno -- 复核机构号
    ,audittellerno -- 复核柜员号
    ,authstatus -- 远程授权任务状态(1-授权等待中、2-授权处理中、3-授权通过、4-授权拒绝、5-授权返回、6-转现场授权、7-授权撤销、8-异常)
    ,authtasknote -- 授权任务备注
    ,authrefusenote -- 授权任务拒绝备注
    ,crttime -- 创建时间
    ,weight -- 权重值
    ,authmodel -- 授权模式(0-本地授权、1-跨终端授权、2-远程授权)
    ,isauthflag -- 是否授权返回（0-否、1-是）
    ,txcode -- 交易码
    ,reasoncode -- 授权原因
    ,barcode -- 影像码
    ,authlevel -- 授权级别
    ,tradestatus -- 交易状态（0-处理中，1-成功，2-失败）
    ,trademode -- 交易模式（1-单交易模式，2-交易包模式）
    ,authreturnnote -- 授权退件备注
    ,authcancelnote -- 授权撤销备注
    ,returntype -- 授权返回原因码
    ,overtime -- 数据日期
    ,cartorder -- 提交购物车批次数（跟购物车组合流水一起，唯一标示每一批购物车交易）
    ,makeupsn -- 购物车授权任务顺序，从1开始
    ,times -- 购物车组合流水
    ,authnote_replenish -- 发起补件备注
    ,replenish_status -- 补件状态
    ,auth_replenish_type -- 补件退回类型
    ,auth_replenish_note -- 补件退回备注
    ,bj_tellerno -- 补件柜员
    ,fqbj_tellerno -- 发起后补件人员
    ,sh_tellerno -- 审核授权人员
    ,bj_authtellerno -- 后补件授权柜员
    ,replenish_note -- 补件备注
    ,replenishflag -- 补件标记。1-后补件;0-默认值，原授权任务，非后补件
    ,start_dt -- 开始时间
    ,end_dt -- 结束时间
    ,id_mark -- 增删标志
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间
)
select
    nvl(txdate, to_date('00010101', 'yyyymmdd')) as txdate -- 交易日期
    ,nvl(trim(txtime), ' ') as txtime -- 交易时间
    ,nvl(trim(tradeserno), ' ') as tradeserno -- 前台交易流水号
    ,nvl(trim(authserno), ' ') as authserno -- 授权流水号（编号规则：6位日期+10位顺序号）
    ,nvl(trim(crtdate), ' ') as crtdate -- 创建日期
    ,nvl(trim(txorgno), ' ') as txorgno -- 交易机构号
    ,nvl(trim(txtellerno), ' ') as txtellerno -- 交易柜员号
    ,nvl(trim(authorgno), ' ') as authorgno -- 授权机构号
    ,nvl(trim(authtellerno), ' ') as authtellerno -- 授权柜员号
    ,nvl(trim(auditorgno), ' ') as auditorgno -- 复核机构号
    ,nvl(trim(audittellerno), ' ') as audittellerno -- 复核柜员号
    ,nvl(trim(authstatus), ' ') as authstatus -- 远程授权任务状态(1-授权等待中、2-授权处理中、3-授权通过、4-授权拒绝、5-授权返回、6-转现场授权、7-授权撤销、8-异常)
    ,nvl(trim(authtasknote), ' ') as authtasknote -- 授权任务备注
    ,nvl(trim(authrefusenote), ' ') as authrefusenote -- 授权任务拒绝备注
    ,nvl(trim(crttime), ' ') as crttime -- 创建时间
    ,nvl(trim(weight), 0) as weight -- 权重值
    ,nvl(trim(authmodel), ' ') as authmodel -- 授权模式(0-本地授权、1-跨终端授权、2-远程授权)
    ,nvl(trim(isauthflag), ' ') as isauthflag -- 是否授权返回（0-否、1-是）
    ,nvl(trim(txcode), ' ') as txcode -- 交易码
    ,nvl(trim(reasoncode), ' ') as reasoncode -- 授权原因
    ,nvl(trim(barcode), ' ') as barcode -- 影像码
    ,nvl(trim(authlevel), ' ') as authlevel -- 授权级别
    ,nvl(trim(tradestatus), ' ') as tradestatus -- 交易状态（0-处理中，1-成功，2-失败）
    ,nvl(trim(trademode), ' ') as trademode -- 交易模式（1-单交易模式，2-交易包模式）
    ,nvl(trim(authreturnnote), ' ') as authreturnnote -- 授权退件备注
    ,nvl(trim(authcancelnote), ' ') as authcancelnote -- 授权撤销备注
    ,nvl(trim(returntype), ' ') as returntype -- 授权返回原因码
    ,nvl(trim(overtime), ' ') as overtime -- 数据日期
    ,nvl(trim(cartorder), 0) as cartorder -- 提交购物车批次数（跟购物车组合流水一起，唯一标示每一批购物车交易）
    ,nvl(trim(makeupsn), ' ') as makeupsn -- 购物车授权任务顺序，从1开始
    ,nvl(trim(times), 0) as times -- 购物车组合流水
    ,nvl(trim(authnote_replenish), ' ') as authnote_replenish -- 发起补件备注
    ,nvl(trim(replenish_status), ' ') as replenish_status -- 补件状态
    ,nvl(trim(auth_replenish_type), ' ') as auth_replenish_type -- 补件退回类型
    ,nvl(trim(auth_replenish_note), ' ') as auth_replenish_note -- 补件退回备注
    ,nvl(trim(bj_tellerno), ' ') as bj_tellerno -- 补件柜员
    ,nvl(trim(fqbj_tellerno), ' ') as fqbj_tellerno -- 发起后补件人员
    ,nvl(trim(sh_tellerno), ' ') as sh_tellerno -- 审核授权人员
    ,nvl(trim(bj_authtellerno), ' ') as bj_authtellerno -- 后补件授权柜员
    ,nvl(trim(replenish_note), ' ') as replenish_note -- 补件备注
    ,nvl(trim(replenishflag), ' ') as replenishflag -- 补件标记。1-后补件;0-默认值，原授权任务，非后补件
    ,nvl(start_dt, to_date('00010101', 'yyyymmdd')) as start_dt -- 开始时间
    ,nvl(end_dt, to_date('00010101', 'yyyymmdd')) as end_dt -- 结束时间
    ,nvl(trim(id_mark), ' ') as id_mark -- 增删标志
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${msl_schema}.msl_edw_ncts_ab_auth_tasktabledtl
where 1 = 1
 ;
commit;

-- 3 table grant
whenever sqlerror exit sql.sqlcode;
grant select on ${itl_schema}.itl_edw_ncts_ab_auth_tasktabledtl to ${idl_schema};

-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${itl_schema}',tabname => 'itl_edw_ncts_ab_auth_tasktabledtl',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);