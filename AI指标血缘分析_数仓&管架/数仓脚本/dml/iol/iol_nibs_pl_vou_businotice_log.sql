/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_nibs_pl_vou_businotice_log
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
drop table ${iol_schema}.nibs_pl_vou_businotice_log_ex purge;
alter table ${iol_schema}.nibs_pl_vou_businotice_log add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.nibs_pl_vou_businotice_log truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.nibs_pl_vou_businotice_log_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.nibs_pl_vou_businotice_log where 0=1;

insert /*+ append */ into ${iol_schema}.nibs_pl_vou_businotice_log_ex(
    noticedate -- 通知日期
    ,remark2 -- 备用字段2
    ,channeldate -- 渠道日期
    ,channelserno -- 渠道流水
    ,channelcode -- 渠道代码
    ,voutype -- 凭证种类
    ,voukind -- 凭证类型 0 客户签字凭证，1交易成功凭证
    ,scenecode -- 第三方交易码
    ,noticestep -- 处理步骤　01-进行pdf加签　02-上传归档平台 03 -已作废
    ,noticestatus -- 处理标识 0-初始　1-成功　2-失败　3-处理中　4-处理异常
    ,procnum -- 处理次数
    ,noticebatchno -- 通知批次号
    ,genidflag -- 归档号生成方式1-平台生成 2－渠道生成
    ,fileupstatus -- 文件上传状态0-初始 1-上传成功 2-平台合成 3-平台处理中 4-处理异常 5-已作废
    ,filepath -- 源文件路径
    ,sourcefilename -- 源文件名
    ,aimfilename -- 加密文件名
    ,aimcontentid -- 影像批次号
    ,filesize -- 文件大小标识
    ,orgid -- 机构编号
    ,tellerid -- 柜员编号
    ,oprdate -- 操作日期
    ,printno -- 打印流水号
    ,dealcode -- 应用处理码
    ,dealmsg -- 应用处理信息
    ,crtdatetime -- 创建时间
    ,altdatetime -- 修改时间
    ,remark -- 备用字段
    ,remark1 -- 备用字段1
    ,noticeserno -- 通知流水
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    noticedate -- 通知日期
    ,remark2 -- 备用字段2
    ,channeldate -- 渠道日期
    ,channelserno -- 渠道流水
    ,channelcode -- 渠道代码
    ,voutype -- 凭证种类
    ,voukind -- 凭证类型 0 客户签字凭证，1交易成功凭证
    ,scenecode -- 第三方交易码
    ,noticestep -- 处理步骤　01-进行pdf加签　02-上传归档平台 03 -已作废
    ,noticestatus -- 处理标识 0-初始　1-成功　2-失败　3-处理中　4-处理异常
    ,procnum -- 处理次数
    ,noticebatchno -- 通知批次号
    ,genidflag -- 归档号生成方式1-平台生成 2－渠道生成
    ,fileupstatus -- 文件上传状态0-初始 1-上传成功 2-平台合成 3-平台处理中 4-处理异常 5-已作废
    ,filepath -- 源文件路径
    ,sourcefilename -- 源文件名
    ,aimfilename -- 加密文件名
    ,aimcontentid -- 影像批次号
    ,filesize -- 文件大小标识
    ,orgid -- 机构编号
    ,tellerid -- 柜员编号
    ,oprdate -- 操作日期
    ,printno -- 打印流水号
    ,dealcode -- 应用处理码
    ,dealmsg -- 应用处理信息
    ,crtdatetime -- 创建时间
    ,altdatetime -- 修改时间
    ,remark -- 备用字段
    ,remark1 -- 备用字段1
    ,noticeserno -- 通知流水
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.nibs_pl_vou_businotice_log
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.nibs_pl_vou_businotice_log exchange partition p_${batch_date} with table ${iol_schema}.nibs_pl_vou_businotice_log_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.nibs_pl_vou_businotice_log to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.nibs_pl_vou_businotice_log_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'nibs_pl_vou_businotice_log',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);