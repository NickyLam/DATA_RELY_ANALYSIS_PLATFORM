/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_anti_money_launder_info
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create backup table
-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iol_schema}.icms_anti_money_launder_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_anti_money_launder_info
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_anti_money_launder_info_op purge;
drop table ${iol_schema}.icms_anti_money_launder_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_anti_money_launder_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_anti_money_launder_info where 0=1;

create table ${iol_schema}.icms_anti_money_launder_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_anti_money_launder_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_anti_money_launder_info_cl(
            serialno -- 流水号
            ,objectno -- 关联流水号
            ,objecttype -- 关联类型
            ,resultcode -- 检索结果代码
            ,resultinfo -- 检索结果
            ,levelname -- 风险等级
            ,recordid -- 检索结果的主表记录ID
            ,warningstatus -- 预警状态
            ,approvestatus -- 审批状态
            ,reasonurl -- 查看预警信息命中原因URL
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputdate -- 登记日期
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,updatedate -- 更新日期
            ,checkresult -- 处理结果：0-待处理；1-放行；2-拦截；X-终止交易
            ,checkcntt -- 审核内容
            ,remark -- 备注
            ,certid -- 证件号码
            ,certtype -- 证件类型
            ,ismoneylaunder -- 是否命中反洗钱
            ,riskadvice -- 风控措施建议
            ,risktype -- 风控措施类别
            ,transid -- 对应发风控最新的事件流水号
            ,customername -- 客户名称
            ,applyphase -- 申请阶段编号
            ,inclusiondate -- 名单收录日期
            ,sourcecode -- 名单来源代码
            ,tokenid -- 反洗钱tokenId
            ,fxqrecordid -- 反洗钱命中预警ID
            ,groupinfo -- 名单命中实际分组
            ,querypriptype -- 查询主体类型
            ,counterpartyaccount -- 交易对手账户
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_anti_money_launder_info_op(
            serialno -- 流水号
            ,objectno -- 关联流水号
            ,objecttype -- 关联类型
            ,resultcode -- 检索结果代码
            ,resultinfo -- 检索结果
            ,levelname -- 风险等级
            ,recordid -- 检索结果的主表记录ID
            ,warningstatus -- 预警状态
            ,approvestatus -- 审批状态
            ,reasonurl -- 查看预警信息命中原因URL
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputdate -- 登记日期
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,updatedate -- 更新日期
            ,checkresult -- 处理结果：0-待处理；1-放行；2-拦截；X-终止交易
            ,checkcntt -- 审核内容
            ,remark -- 备注
            ,certid -- 证件号码
            ,certtype -- 证件类型
            ,ismoneylaunder -- 是否命中反洗钱
            ,riskadvice -- 风控措施建议
            ,risktype -- 风控措施类别
            ,transid -- 对应发风控最新的事件流水号
            ,customername -- 客户名称
            ,applyphase -- 申请阶段编号
            ,inclusiondate -- 名单收录日期
            ,sourcecode -- 名单来源代码
            ,tokenid -- 反洗钱tokenId
            ,fxqrecordid -- 反洗钱命中预警ID
            ,groupinfo -- 名单命中实际分组
            ,querypriptype -- 查询主体类型
            ,counterpartyaccount -- 交易对手账户
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.serialno, o.serialno) as serialno -- 流水号
    ,nvl(n.objectno, o.objectno) as objectno -- 关联流水号
    ,nvl(n.objecttype, o.objecttype) as objecttype -- 关联类型
    ,nvl(n.resultcode, o.resultcode) as resultcode -- 检索结果代码
    ,nvl(n.resultinfo, o.resultinfo) as resultinfo -- 检索结果
    ,nvl(n.levelname, o.levelname) as levelname -- 风险等级
    ,nvl(n.recordid, o.recordid) as recordid -- 检索结果的主表记录ID
    ,nvl(n.warningstatus, o.warningstatus) as warningstatus -- 预警状态
    ,nvl(n.approvestatus, o.approvestatus) as approvestatus -- 审批状态
    ,nvl(n.reasonurl, o.reasonurl) as reasonurl -- 查看预警信息命中原因URL
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 登记人
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 登记机构
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记日期
    ,nvl(n.updateuserid, o.updateuserid) as updateuserid -- 更新人
    ,nvl(n.updateorgid, o.updateorgid) as updateorgid -- 更新机构
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新日期
    ,nvl(n.checkresult, o.checkresult) as checkresult -- 处理结果：0-待处理；1-放行；2-拦截；X-终止交易
    ,nvl(n.checkcntt, o.checkcntt) as checkcntt -- 审核内容
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.certid, o.certid) as certid -- 证件号码
    ,nvl(n.certtype, o.certtype) as certtype -- 证件类型
    ,nvl(n.ismoneylaunder, o.ismoneylaunder) as ismoneylaunder -- 是否命中反洗钱
    ,nvl(n.riskadvice, o.riskadvice) as riskadvice -- 风控措施建议
    ,nvl(n.risktype, o.risktype) as risktype -- 风控措施类别
    ,nvl(n.transid, o.transid) as transid -- 对应发风控最新的事件流水号
    ,nvl(n.customername, o.customername) as customername -- 客户名称
    ,nvl(n.applyphase, o.applyphase) as applyphase -- 申请阶段编号
    ,nvl(n.inclusiondate, o.inclusiondate) as inclusiondate -- 名单收录日期
    ,nvl(n.sourcecode, o.sourcecode) as sourcecode -- 名单来源代码
    ,nvl(n.tokenid, o.tokenid) as tokenid -- 反洗钱tokenId
    ,nvl(n.fxqrecordid, o.fxqrecordid) as fxqrecordid -- 反洗钱命中预警ID
    ,nvl(n.groupinfo, o.groupinfo) as groupinfo -- 名单命中实际分组
    ,nvl(n.querypriptype, o.querypriptype) as querypriptype -- 查询主体类型
    ,nvl(n.counterpartyaccount, o.counterpartyaccount) as counterpartyaccount -- 交易对手账户
    ,case when
            n.serialno is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.serialno is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.serialno is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_anti_money_launder_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_anti_money_launder_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.serialno = n.serialno
where (
        o.serialno is null
    )
    or (
        n.serialno is null
    )
    or (
        o.objectno <> n.objectno
        or o.objecttype <> n.objecttype
        or o.resultcode <> n.resultcode
        or o.resultinfo <> n.resultinfo
        or o.levelname <> n.levelname
        or o.recordid <> n.recordid
        or o.warningstatus <> n.warningstatus
        or o.approvestatus <> n.approvestatus
        or o.reasonurl <> n.reasonurl
        or o.inputuserid <> n.inputuserid
        or o.inputorgid <> n.inputorgid
        or o.inputdate <> n.inputdate
        or o.updateuserid <> n.updateuserid
        or o.updateorgid <> n.updateorgid
        or o.updatedate <> n.updatedate
        or o.checkresult <> n.checkresult
        or o.checkcntt <> n.checkcntt
        or o.remark <> n.remark
        or o.certid <> n.certid
        or o.certtype <> n.certtype
        or o.ismoneylaunder <> n.ismoneylaunder
        or o.riskadvice <> n.riskadvice
        or o.risktype <> n.risktype
        or o.transid <> n.transid
        or o.customername <> n.customername
        or o.applyphase <> n.applyphase
        or o.inclusiondate <> n.inclusiondate
        or o.sourcecode <> n.sourcecode
        or o.tokenid <> n.tokenid
        or o.fxqrecordid <> n.fxqrecordid
        or o.groupinfo <> n.groupinfo
        or o.querypriptype <> n.querypriptype
        or o.counterpartyaccount <> n.counterpartyaccount
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_anti_money_launder_info_cl(
            serialno -- 流水号
            ,objectno -- 关联流水号
            ,objecttype -- 关联类型
            ,resultcode -- 检索结果代码
            ,resultinfo -- 检索结果
            ,levelname -- 风险等级
            ,recordid -- 检索结果的主表记录ID
            ,warningstatus -- 预警状态
            ,approvestatus -- 审批状态
            ,reasonurl -- 查看预警信息命中原因URL
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputdate -- 登记日期
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,updatedate -- 更新日期
            ,checkresult -- 处理结果：0-待处理；1-放行；2-拦截；X-终止交易
            ,checkcntt -- 审核内容
            ,remark -- 备注
            ,certid -- 证件号码
            ,certtype -- 证件类型
            ,ismoneylaunder -- 是否命中反洗钱
            ,riskadvice -- 风控措施建议
            ,risktype -- 风控措施类别
            ,transid -- 对应发风控最新的事件流水号
            ,customername -- 客户名称
            ,applyphase -- 申请阶段编号
            ,inclusiondate -- 名单收录日期
            ,sourcecode -- 名单来源代码
            ,tokenid -- 反洗钱tokenId
            ,fxqrecordid -- 反洗钱命中预警ID
            ,groupinfo -- 名单命中实际分组
            ,querypriptype -- 查询主体类型
            ,counterpartyaccount -- 交易对手账户
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_anti_money_launder_info_op(
            serialno -- 流水号
            ,objectno -- 关联流水号
            ,objecttype -- 关联类型
            ,resultcode -- 检索结果代码
            ,resultinfo -- 检索结果
            ,levelname -- 风险等级
            ,recordid -- 检索结果的主表记录ID
            ,warningstatus -- 预警状态
            ,approvestatus -- 审批状态
            ,reasonurl -- 查看预警信息命中原因URL
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputdate -- 登记日期
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,updatedate -- 更新日期
            ,checkresult -- 处理结果：0-待处理；1-放行；2-拦截；X-终止交易
            ,checkcntt -- 审核内容
            ,remark -- 备注
            ,certid -- 证件号码
            ,certtype -- 证件类型
            ,ismoneylaunder -- 是否命中反洗钱
            ,riskadvice -- 风控措施建议
            ,risktype -- 风控措施类别
            ,transid -- 对应发风控最新的事件流水号
            ,customername -- 客户名称
            ,applyphase -- 申请阶段编号
            ,inclusiondate -- 名单收录日期
            ,sourcecode -- 名单来源代码
            ,tokenid -- 反洗钱tokenId
            ,fxqrecordid -- 反洗钱命中预警ID
            ,groupinfo -- 名单命中实际分组
            ,querypriptype -- 查询主体类型
            ,counterpartyaccount -- 交易对手账户
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serialno -- 流水号
    ,o.objectno -- 关联流水号
    ,o.objecttype -- 关联类型
    ,o.resultcode -- 检索结果代码
    ,o.resultinfo -- 检索结果
    ,o.levelname -- 风险等级
    ,o.recordid -- 检索结果的主表记录ID
    ,o.warningstatus -- 预警状态
    ,o.approvestatus -- 审批状态
    ,o.reasonurl -- 查看预警信息命中原因URL
    ,o.inputuserid -- 登记人
    ,o.inputorgid -- 登记机构
    ,o.inputdate -- 登记日期
    ,o.updateuserid -- 更新人
    ,o.updateorgid -- 更新机构
    ,o.updatedate -- 更新日期
    ,o.checkresult -- 处理结果：0-待处理；1-放行；2-拦截；X-终止交易
    ,o.checkcntt -- 审核内容
    ,o.remark -- 备注
    ,o.certid -- 证件号码
    ,o.certtype -- 证件类型
    ,o.ismoneylaunder -- 是否命中反洗钱
    ,o.riskadvice -- 风控措施建议
    ,o.risktype -- 风控措施类别
    ,o.transid -- 对应发风控最新的事件流水号
    ,o.customername -- 客户名称
    ,o.applyphase -- 申请阶段编号
    ,o.inclusiondate -- 名单收录日期
    ,o.sourcecode -- 名单来源代码
    ,o.tokenid -- 反洗钱tokenId
    ,o.fxqrecordid -- 反洗钱命中预警ID
    ,o.groupinfo -- 名单命中实际分组
    ,o.querypriptype -- 查询主体类型
    ,o.counterpartyaccount -- 交易对手账户
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,case when n.start_dt is not null
          then 'I'
          when o.end_dt >= to_date('${batch_date}','yyyymmdd')
          then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志 
    ,o.etl_timestamp -- ETL处理时间
from ${iol_schema}.icms_anti_money_launder_info_bk o
    left join ${iol_schema}.icms_anti_money_launder_info_op n
        on
            o.serialno = n.serialno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_anti_money_launder_info_cl d
        on
            o.serialno = d.serialno
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_anti_money_launder_info;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_anti_money_launder_info') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_anti_money_launder_info drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_anti_money_launder_info add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_anti_money_launder_info exchange partition p_${batch_date} with table ${iol_schema}.icms_anti_money_launder_info_cl;
alter table ${iol_schema}.icms_anti_money_launder_info exchange partition p_20991231 with table ${iol_schema}.icms_anti_money_launder_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_anti_money_launder_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_anti_money_launder_info_op purge;
drop table ${iol_schema}.icms_anti_money_launder_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_anti_money_launder_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_anti_money_launder_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
