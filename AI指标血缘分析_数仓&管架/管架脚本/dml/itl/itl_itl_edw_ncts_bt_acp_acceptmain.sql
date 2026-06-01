/*
Purpose:    技术缓冲层脚本，把数据文件加载到目标表的当天分区中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd itl_itl_edw_ncts_bt_acp_acceptmain
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
alter table ${itl_schema}.itl_edw_ncts_bt_acp_acceptmain drop partition p_${retain_day};
alter table ${itl_schema}.itl_edw_ncts_bt_acp_acceptmain drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${itl_schema}.itl_edw_ncts_bt_acp_acceptmain add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${itl_schema}.itl_edw_ncts_bt_acp_acceptmain partition for (to_date('${batch_date}','yyyymmdd')) (
    tradeserno -- 预受理编号
    ,oldtradeserno -- 原预受理编号
    ,biztype -- 业务类型
    ,status -- 状态
    ,busiserno -- 交易流水
    ,channelcode -- 发起渠道
    ,acctno -- 账号
    ,acctname -- 户名
    ,custno -- 客户号
    ,idtype -- 证件类型
    ,idno -- 证据号码
    ,idname -- 证件名称
    ,agentidtype -- 代理人证件类型
    ,agentidno -- 代理人证件号码
    ,agentidname -- 代理人证件名称
    ,remark -- 备注|预审结论
    ,createdate -- 创建日期
    ,createtime -- 创建时间
    ,createby -- 创建柜员
    ,updatedate -- 更新日期
    ,updatetime -- 更新时间
    ,updateby -- 更新柜员
    ,reftradeserno -- 流程银行受理流水号
    ,applydate -- 申请日期
    ,applybrno -- 申请机构
    ,phone -- 手机号码
    ,reserv_id -- 预约编号
    ,tellerphone -- 柜员手机号
    ,start_dt -- 开始时间
    ,end_dt -- 结束时间
    ,id_mark -- 增删标志
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间
)
select
    nvl(trim(tradeserno), ' ') as tradeserno -- 预受理编号
    ,nvl(trim(oldtradeserno), ' ') as oldtradeserno -- 原预受理编号
    ,nvl(trim(biztype), ' ') as biztype -- 业务类型
    ,nvl(trim(status), ' ') as status -- 状态
    ,nvl(trim(busiserno), ' ') as busiserno -- 交易流水
    ,nvl(trim(channelcode), ' ') as channelcode -- 发起渠道
    ,nvl(trim(acctno), ' ') as acctno -- 账号
    ,nvl(trim(acctname), ' ') as acctname -- 户名
    ,nvl(trim(custno), ' ') as custno -- 客户号
    ,nvl(trim(idtype), ' ') as idtype -- 证件类型
    ,nvl(trim(idno), ' ') as idno -- 证据号码
    ,nvl(trim(idname), ' ') as idname -- 证件名称
    ,nvl(trim(agentidtype), ' ') as agentidtype -- 代理人证件类型
    ,nvl(trim(agentidno), ' ') as agentidno -- 代理人证件号码
    ,nvl(trim(agentidname), ' ') as agentidname -- 代理人证件名称
    ,nvl(trim(remark), ' ') as remark -- 备注|预审结论
    ,nvl(createdate, to_date('00010101', 'yyyymmdd')) as createdate -- 创建日期
    ,nvl(trim(createtime), ' ') as createtime -- 创建时间
    ,nvl(trim(createby), ' ') as createby -- 创建柜员
    ,nvl(updatedate, to_date('00010101', 'yyyymmdd')) as updatedate -- 更新日期
    ,nvl(trim(updatetime), ' ') as updatetime -- 更新时间
    ,nvl(trim(updateby), ' ') as updateby -- 更新柜员
    ,nvl(trim(reftradeserno), ' ') as reftradeserno -- 流程银行受理流水号
    ,nvl(trim(applydate), ' ') as applydate -- 申请日期
    ,nvl(trim(applybrno), ' ') as applybrno -- 申请机构
    ,nvl(trim(phone), ' ') as phone -- 手机号码
    ,nvl(trim(reserv_id), ' ') as reserv_id -- 预约编号
    ,nvl(trim(tellerphone), ' ') as tellerphone -- 柜员手机号
    ,nvl(start_dt, to_date('00010101', 'yyyymmdd')) as start_dt -- 开始时间
    ,nvl(end_dt, to_date('00010101', 'yyyymmdd')) as end_dt -- 结束时间
    ,nvl(trim(id_mark), ' ') as id_mark -- 增删标志
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${msl_schema}.msl_edw_ncts_bt_acp_acceptmain
where 1 = 1
 ;
commit;

-- 3 table grant
whenever sqlerror exit sql.sqlcode;
grant select on ${itl_schema}.itl_edw_ncts_bt_acp_acceptmain to ${idl_schema};

-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${itl_schema}',tabname => 'itl_edw_ncts_bt_acp_acceptmain',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);