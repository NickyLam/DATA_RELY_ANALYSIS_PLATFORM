/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mpcs_a68tszfsdiskno
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
drop table ${iol_schema}.mpcs_a68tszfsdiskno_ex purge;
alter table ${iol_schema}.mpcs_a68tszfsdiskno add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${iol_schema}.mpcs_a68tszfsdiskno;

-- 2.3 insert data to ex table
create table ${iol_schema}.mpcs_a68tszfsdiskno_ex nologging
compress
as
select * from ${iol_schema}.mpcs_a68tszfsdiskno where 0=1;

insert /*+ append */ into ${iol_schema}.mpcs_a68tszfsdiskno_ex(
    diskno -- 定期业务批次号
    ,magbrn -- 提交网点号
    ,oprtlr -- 操作柜员
    ,chktlr -- 复核柜员
    ,unitcd -- 单位代码
    ,cntrno -- 协议号
    ,tempacct -- 单位代码对应帐号
    ,pckno -- PKG包类型号
    ,txtpcd -- 业务类型(行外)
    ,txcd -- 业务编号
    ,transdt -- 批次提出日期
    ,deadline -- 回执期限
    ,rtrltd -- 回执日期
    ,backdate -- 生成客户回盘日期(贷记业务是提出磁盘日期的下一工作日,借记业务是回执最后期限的下一工作日)
    ,status -- 批次行外提出状态Z 录入未完成 B 已录入 a 复核未完成 A 已复核 Q 已组包待发送 S 已成功发送 T 已完成
    ,innerstatus -- 批次行内提出状态Z 录入未完成 B 已录入 a 复核未完成 A 已复核 T 已完成
    ,totalnum -- 批次总笔数
    ,totalamt -- 批次总金额
    ,succeedtotalnum -- 总的成功笔数
    ,succeedtotalamt -- 总的成功金额
    ,innertotalnum -- 行内总笔数
    ,innertotalamt -- 行内总金额
    ,innersucceedtotalnum -- 行内成功总笔数
    ,innersucceedtotalamt -- 行内成功总金额
    ,outertotalnum -- 行外总笔数
    ,outertotalamt -- 行外总金额
    ,outersucceedtotalnum -- 行外成功总笔数
    ,outersucceedtotalamt -- 行外成功总金额
    ,opennode -- 单位代码对应开户行号
    ,corpacct -- 企业帐号
    ,corpname -- 企业帐号户名
    ,message -- 返回信息
    ,hostdate -- 主机日期
    ,hostnbr -- 主机流水
    ,itmscd -- 费项代码
    ,pmtitmnm -- 费项简称
    ,ctrctchckflg -- 是否已检查协议 1：检查通过
    ,cdtrnmflg -- 收款方是否带户名标志 0:带户名 1:不带户名
    ,areacd -- 地区代码
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    diskno -- 定期业务批次号
    ,magbrn -- 提交网点号
    ,oprtlr -- 操作柜员
    ,chktlr -- 复核柜员
    ,unitcd -- 单位代码
    ,cntrno -- 协议号
    ,tempacct -- 单位代码对应帐号
    ,pckno -- PKG包类型号
    ,txtpcd -- 业务类型(行外)
    ,txcd -- 业务编号
    ,transdt -- 批次提出日期
    ,deadline -- 回执期限
    ,rtrltd -- 回执日期
    ,backdate -- 生成客户回盘日期(贷记业务是提出磁盘日期的下一工作日,借记业务是回执最后期限的下一工作日)
    ,status -- 批次行外提出状态Z 录入未完成 B 已录入 a 复核未完成 A 已复核 Q 已组包待发送 S 已成功发送 T 已完成
    ,innerstatus -- 批次行内提出状态Z 录入未完成 B 已录入 a 复核未完成 A 已复核 T 已完成
    ,totalnum -- 批次总笔数
    ,totalamt -- 批次总金额
    ,succeedtotalnum -- 总的成功笔数
    ,succeedtotalamt -- 总的成功金额
    ,innertotalnum -- 行内总笔数
    ,innertotalamt -- 行内总金额
    ,innersucceedtotalnum -- 行内成功总笔数
    ,innersucceedtotalamt -- 行内成功总金额
    ,outertotalnum -- 行外总笔数
    ,outertotalamt -- 行外总金额
    ,outersucceedtotalnum -- 行外成功总笔数
    ,outersucceedtotalamt -- 行外成功总金额
    ,opennode -- 单位代码对应开户行号
    ,corpacct -- 企业帐号
    ,corpname -- 企业帐号户名
    ,message -- 返回信息
    ,hostdate -- 主机日期
    ,hostnbr -- 主机流水
    ,itmscd -- 费项代码
    ,pmtitmnm -- 费项简称
    ,ctrctchckflg -- 是否已检查协议 1：检查通过
    ,cdtrnmflg -- 收款方是否带户名标志 0:带户名 1:不带户名
    ,areacd -- 地区代码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.mpcs_a68tszfsdiskno
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.mpcs_a68tszfsdiskno exchange partition p_${batch_date} with table ${iol_schema}.mpcs_a68tszfsdiskno_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mpcs_a68tszfsdiskno to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.mpcs_a68tszfsdiskno_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mpcs_a68tszfsdiskno',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);