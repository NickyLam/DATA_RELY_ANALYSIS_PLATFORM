/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_imps_yx_act_join_detail_out
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create table for exchage and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.imps_yx_act_join_detail_out_ex purge;
alter table ${iol_schema}.imps_yx_act_join_detail_out add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.imps_yx_act_join_detail_out truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.imps_yx_act_join_detail_out_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.imps_yx_act_join_detail_out where 0=1;

insert /*+ append */ into ${iol_schema}.imps_yx_act_join_detail_out_ex(
    p_date -- 分区日期
    ,hostcustno -- 银行客户号
    ,actid -- 活动编号
    ,actname -- 活动名称
    ,tooltypename -- 工具类型名称
    ,jointime -- 参与时间
    ,score -- 分数
    ,gametime -- 用时（s）
    ,whethersuccess -- 挑战结果(成功/失败)
    ,winning -- 是否中奖
    ,orderno -- 订单编号
    ,prizename -- 礼品名称
    ,receiveinvalidtime -- 领取有效期
    ,orderstatus -- 订单状态
    ,cardcouponsexpirationdate -- 卡券有效期
    ,cardcouponswriteoffdate -- 卡券核销时间
    ,pricemoney -- 礼品价值
    ,signreward -- 签到奖励
    ,guessstate -- 竞猜结果
    ,guesswinpoints -- 奖励数
    ,inviteeshostcustno -- 被邀请人客户号
    ,invitationstatus -- 邀请状态
    ,votingworkname -- 参赛作品名称
    ,receivedvotes -- 收到投票数
    ,lootjoinnumber -- 夺宝号
    ,consumptiontotalpoints -- 捐赠总消耗
    ,donattotalcount -- 捐赠总笔数
    ,totalguesscount -- 竞猜次数
    ,guesssuccesscount -- 竞猜正确次数
    ,totalguesssuccesspoints -- 获得奖励累计
    ,datatime -- 数据日期
    ,returntime -- 回流日期
    ,baseid -- 
    ,row_id -- 数据行号
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    p_date -- 分区日期
    ,hostcustno -- 银行客户号
    ,actid -- 活动编号
    ,actname -- 活动名称
    ,tooltypename -- 工具类型名称
    ,jointime -- 参与时间
    ,score -- 分数
    ,gametime -- 用时（s）
    ,whethersuccess -- 挑战结果(成功/失败)
    ,winning -- 是否中奖
    ,orderno -- 订单编号
    ,prizename -- 礼品名称
    ,receiveinvalidtime -- 领取有效期
    ,orderstatus -- 订单状态
    ,cardcouponsexpirationdate -- 卡券有效期
    ,cardcouponswriteoffdate -- 卡券核销时间
    ,pricemoney -- 礼品价值
    ,signreward -- 签到奖励
    ,guessstate -- 竞猜结果
    ,guesswinpoints -- 奖励数
    ,inviteeshostcustno -- 被邀请人客户号
    ,invitationstatus -- 邀请状态
    ,votingworkname -- 参赛作品名称
    ,receivedvotes -- 收到投票数
    ,lootjoinnumber -- 夺宝号
    ,consumptiontotalpoints -- 捐赠总消耗
    ,donattotalcount -- 捐赠总笔数
    ,totalguesscount -- 竞猜次数
    ,guesssuccesscount -- 竞猜正确次数
    ,totalguesssuccesspoints -- 获得奖励累计
    ,datatime -- 数据日期
    ,returntime -- 回流日期
    ,baseid -- 
    ,row_id -- 数据行号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.imps_yx_act_join_detail_out
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.imps_yx_act_join_detail_out exchange partition p_${batch_date} with table ${iol_schema}.imps_yx_act_join_detail_out_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.imps_yx_act_join_detail_out to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.imps_yx_act_join_detail_out_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'imps_yx_act_join_detail_out',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);