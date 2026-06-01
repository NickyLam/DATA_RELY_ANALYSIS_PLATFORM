/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_nibs_pl_vou_vouserial_log
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
drop table ${iol_schema}.nibs_pl_vou_vouserial_log_ex purge;
alter table ${iol_schema}.nibs_pl_vou_vouserial_log add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.nibs_pl_vou_vouserial_log truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.nibs_pl_vou_vouserial_log_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.nibs_pl_vou_vouserial_log where 0=1;

insert /*+ append */ into ${iol_schema}.nibs_pl_vou_vouserial_log_ex(
    elecdocdate -- 电子凭证日期
    ,remark2 -- 备注2
    ,elecdockind -- 1-第三方联机网银模式,2-第三方联机自助设备模式,3-第三方控件形态，4-日终批量 5-第三方联机网贷模式
    ,elecdoctime -- 电子凭证生成时间
    ,chanelcode -- 交易渠道编号
    ,chaneldate -- 渠道日期
    ,chaneltime -- 渠道时间
    ,printno -- 渠道打印流水号（关联各系统自己的凭证打印）
    ,hostserialno -- 主机流水号
    ,tradecode -- 交易码
    ,tradename -- 交易名称
    ,oprbranch -- 操作机构编号
    ,oprteller -- 操作柜员编号
    ,voutype -- 凭证种类
    ,vouname -- 凭证名称
    ,scenecode -- 场景码
    ,content -- 打印信息主联
    ,content1 -- 打印信息副联
    ,voumodelid -- 电子凭证id号
    ,vousaveid -- 电子凭证归档号
    ,genidflag -- 归档号生成方式1-平台生成 2－渠道生成
    ,status -- 凭证状态 1-正常 4-作废
    ,userconfirmflg -- 用户确认方式（0-签名、1-指纹）
    ,userconfirmdata -- 用户确认数据
    ,fileuserinfo -- 归档文件用户信息,相关字段以@@分隔
    ,remark -- 备注
    ,remark1 -- 备注1
    ,elecdocno -- 电子凭证流水号
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    elecdocdate -- 电子凭证日期
    ,remark2 -- 备注2
    ,elecdockind -- 1-第三方联机网银模式,2-第三方联机自助设备模式,3-第三方控件形态，4-日终批量 5-第三方联机网贷模式
    ,elecdoctime -- 电子凭证生成时间
    ,chanelcode -- 交易渠道编号
    ,chaneldate -- 渠道日期
    ,chaneltime -- 渠道时间
    ,printno -- 渠道打印流水号（关联各系统自己的凭证打印）
    ,hostserialno -- 主机流水号
    ,tradecode -- 交易码
    ,tradename -- 交易名称
    ,oprbranch -- 操作机构编号
    ,oprteller -- 操作柜员编号
    ,voutype -- 凭证种类
    ,vouname -- 凭证名称
    ,scenecode -- 场景码
    ,content -- 打印信息主联
    ,content1 -- 打印信息副联
    ,voumodelid -- 电子凭证id号
    ,vousaveid -- 电子凭证归档号
    ,genidflag -- 归档号生成方式1-平台生成 2－渠道生成
    ,status -- 凭证状态 1-正常 4-作废
    ,userconfirmflg -- 用户确认方式（0-签名、1-指纹）
    ,userconfirmdata -- 用户确认数据
    ,fileuserinfo -- 归档文件用户信息,相关字段以@@分隔
    ,remark -- 备注
    ,remark1 -- 备注1
    ,elecdocno -- 电子凭证流水号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.nibs_pl_vou_vouserial_log
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.nibs_pl_vou_vouserial_log exchange partition p_${batch_date} with table ${iol_schema}.nibs_pl_vou_vouserial_log_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.nibs_pl_vou_vouserial_log to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.nibs_pl_vou_vouserial_log_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'nibs_pl_vou_vouserial_log',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);