/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mpcs_a60projdf_sign_summary
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
drop table ${iol_schema}.mpcs_a60projdf_sign_summary_ex purge;
alter table ${iol_schema}.mpcs_a60projdf_sign_summary add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.mpcs_a60projdf_sign_summary truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.mpcs_a60projdf_sign_summary_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a60projdf_sign_summary where 0=1;

insert /*+ append */ into ${iol_schema}.mpcs_a60projdf_sign_summary_ex(
    projno -- 项目编号
    ,summsq -- 批扣流水
    ,bachdt -- 批次日期
    ,bachsq -- 批次流水
    ,datfna -- 批次数据文件名
    ,mmtext -- 代发摘要
    ,mmcont -- 自定义摘要
    ,projtp -- 项目名称  05.代发 00.代扣 09.开卡
    ,payacc -- 扣款账号
    ,paynam -- 扣款账号名称
    ,tranno -- 笔数
    ,tranam -- 总金额
    ,succno -- 成功笔数
    ,succam -- 成功金额总数
    ,failno -- 失败笔数
    ,failam -- 失败金额总数
    ,branch -- 经办网点
    ,tlrnbr -- 经办柜员
    ,opendcmt -- 凭证类型
    ,opendcno -- 起始账号
    ,transt -- 交易状态 0-未知  1 分析完成  2-发送到核心  3-核心已返回 4-已完成 5-待转账
    ,prtdt -- 打印日期
    ,chktlr -- 授权人
    ,transq -- 交易流水 从核心取
    ,dcmtno -- 凭证起始号
    ,payadr -- 单位地址
    ,paytel -- 单位电话
    ,enflag -- 加密标志 0 明文 1密文
    ,trflag -- 辅助标志 transt=0 1读文件 0完成
    ,errmsg -- 错误信息
    ,iccdfg -- 芯片标志 0否芯片  1 是芯片
    ,coopcd -- 
    ,agstyp -- 电话激活标志
    ,trantp -- 批量处理交易类型
    ,signst -- 签约状态 0-处理中 1-处理完成
    ,realacctno -- 实际扣款/收款账号
    ,hostseqno -- 核心交易流水
    ,hostdt -- 核心交易日期
    ,transeqno -- 中台交易流水号(用于销凭证撤销)
    ,cardkind -- 
    ,proc_times -- 批次处理次数
    ,core_bach_sq -- 核心返回批次号
    ,isinact -- 内部户标志
    ,cardpbind -- 卡bin
    ,prodtype -- 产品类型
    ,openccy -- 币种
    ,clienttype -- 客户类型
    ,categorytype -- 客户细分类型
    ,withdrawaltype -- 支取方式
    ,narrativecode -- 摘要码
    ,contacttype -- 联系类型
    ,vouchstartno -- 凭证起始号
    ,batchopentype -- 批次类型
    ,callstat5 -- 批量开卡调用核心1400-0150接口状态
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    projno -- 项目编号
    ,summsq -- 批扣流水
    ,bachdt -- 批次日期
    ,bachsq -- 批次流水
    ,datfna -- 批次数据文件名
    ,mmtext -- 代发摘要
    ,mmcont -- 自定义摘要
    ,projtp -- 项目名称  05.代发 00.代扣 09.开卡
    ,payacc -- 扣款账号
    ,paynam -- 扣款账号名称
    ,tranno -- 笔数
    ,tranam -- 总金额
    ,succno -- 成功笔数
    ,succam -- 成功金额总数
    ,failno -- 失败笔数
    ,failam -- 失败金额总数
    ,branch -- 经办网点
    ,tlrnbr -- 经办柜员
    ,opendcmt -- 凭证类型
    ,opendcno -- 起始账号
    ,transt -- 交易状态 0-未知  1 分析完成  2-发送到核心  3-核心已返回 4-已完成 5-待转账
    ,prtdt -- 打印日期
    ,chktlr -- 授权人
    ,transq -- 交易流水 从核心取
    ,dcmtno -- 凭证起始号
    ,payadr -- 单位地址
    ,paytel -- 单位电话
    ,enflag -- 加密标志 0 明文 1密文
    ,trflag -- 辅助标志 transt=0 1读文件 0完成
    ,errmsg -- 错误信息
    ,iccdfg -- 芯片标志 0否芯片  1 是芯片
    ,coopcd -- 
    ,agstyp -- 电话激活标志
    ,trantp -- 批量处理交易类型
    ,signst -- 签约状态 0-处理中 1-处理完成
    ,realacctno -- 实际扣款/收款账号
    ,hostseqno -- 核心交易流水
    ,hostdt -- 核心交易日期
    ,transeqno -- 中台交易流水号(用于销凭证撤销)
    ,cardkind -- 
    ,proc_times -- 批次处理次数
    ,core_bach_sq -- 核心返回批次号
    ,isinact -- 内部户标志
    ,cardpbind -- 卡bin
    ,prodtype -- 产品类型
    ,openccy -- 币种
    ,clienttype -- 客户类型
    ,categorytype -- 客户细分类型
    ,withdrawaltype -- 支取方式
    ,narrativecode -- 摘要码
    ,contacttype -- 联系类型
    ,vouchstartno -- 凭证起始号
    ,batchopentype -- 批次类型
    ,callstat5 -- 批量开卡调用核心1400-0150接口状态
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.mpcs_a60projdf_sign_summary
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.mpcs_a60projdf_sign_summary exchange partition p_${batch_date} with table ${iol_schema}.mpcs_a60projdf_sign_summary_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mpcs_a60projdf_sign_summary to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.mpcs_a60projdf_sign_summary_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mpcs_a60projdf_sign_summary',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);