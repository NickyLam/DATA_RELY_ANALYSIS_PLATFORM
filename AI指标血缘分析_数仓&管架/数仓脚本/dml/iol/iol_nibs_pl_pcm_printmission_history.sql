/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_nibs_pl_pcm_printmission_history
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
drop table ${iol_schema}.nibs_pl_pcm_printmission_history_ex purge;
alter table ${iol_schema}.nibs_pl_pcm_printmission_history add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${iol_schema}.nibs_pl_pcm_printmission_history;

-- 2.3 insert data to ex table
create table ${iol_schema}.nibs_pl_pcm_printmission_history_ex nologging
compress
as
select * from ${iol_schema}.nibs_pl_pcm_printmission_history where 0=1;

insert /*+ append */ into ${iol_schema}.nibs_pl_pcm_printmission_history_ex(
    transdate -- 申请日期
    ,transtime -- 申请时间
    ,brno -- 机构号
    ,idcode -- 识别码
    ,busiserialno -- 业务流水
    ,transcode -- 交易码
    ,transname -- 交易名称
    ,prooftype -- 凭证类型
    ,proofnum -- 凭证联数
    ,sealnum -- 印章编号
    ,proofno -- 凭证号码
    ,printtype -- 用印类型  0-自动用印 1-手动用印 2-流水勾兑
    ,missionstatus -- 任务状态 0-未盖章 1-识别识别码异常 2-第一次拍照异常 3-盖章异常 4-第二次拍照异常 5-照片合成异常 6-影像流水上传异常 7-已盖章 8-已作废 9-超期作废
    ,printdate -- 用印日期
    ,teller -- 申请柜员
    ,authorize -- 授权柜员
    ,authorg -- 授权柜员机构
    ,channel -- 渠道
    ,acctno -- 账号
    ,acctname -- 户名
    ,photobeofre -- 第一张照片在服务器的地址
    ,photoafter -- 第二张照片在服务器的地址
    ,photocombination -- 合成照片在服务器的地址
    ,pcmno -- 印控机编号
    ,idcount -- 需要盖章次数
    ,changetime -- 状态废除时间
    ,changestatus -- 废除前状态
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    transdate -- 申请日期
    ,transtime -- 申请时间
    ,brno -- 机构号
    ,idcode -- 识别码
    ,busiserialno -- 业务流水
    ,transcode -- 交易码
    ,transname -- 交易名称
    ,prooftype -- 凭证类型
    ,proofnum -- 凭证联数
    ,sealnum -- 印章编号
    ,proofno -- 凭证号码
    ,printtype -- 用印类型  0-自动用印 1-手动用印 2-流水勾兑
    ,missionstatus -- 任务状态 0-未盖章 1-识别识别码异常 2-第一次拍照异常 3-盖章异常 4-第二次拍照异常 5-照片合成异常 6-影像流水上传异常 7-已盖章 8-已作废 9-超期作废
    ,printdate -- 用印日期
    ,teller -- 申请柜员
    ,authorize -- 授权柜员
    ,authorg -- 授权柜员机构
    ,channel -- 渠道
    ,acctno -- 账号
    ,acctname -- 户名
    ,photobeofre -- 第一张照片在服务器的地址
    ,photoafter -- 第二张照片在服务器的地址
    ,photocombination -- 合成照片在服务器的地址
    ,pcmno -- 印控机编号
    ,idcount -- 需要盖章次数
    ,changetime -- 状态废除时间
    ,changestatus -- 废除前状态
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.nibs_pl_pcm_printmission_history
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.nibs_pl_pcm_printmission_history exchange partition p_${batch_date} with table ${iol_schema}.nibs_pl_pcm_printmission_history_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.nibs_pl_pcm_printmission_history to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.nibs_pl_pcm_printmission_history_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'nibs_pl_pcm_printmission_history',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);