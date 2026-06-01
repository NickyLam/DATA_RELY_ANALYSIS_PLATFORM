/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_nhrs_hi_psndoc_ctrt
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
create table ${iol_schema}.nhrs_hi_psndoc_ctrt_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.nhrs_hi_psndoc_ctrt
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.nhrs_hi_psndoc_ctrt_op purge;
drop table ${iol_schema}.nhrs_hi_psndoc_ctrt_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nhrs_hi_psndoc_ctrt_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.nhrs_hi_psndoc_ctrt where 0=1;

create table ${iol_schema}.nhrs_hi_psndoc_ctrt_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.nhrs_hi_psndoc_ctrt where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.nhrs_hi_psndoc_ctrt_cl(
            assgid -- 人员任职ID
            ,begindate -- 合同开始日期
            ,breachmoney -- 赔偿金
            ,cont_unit -- 合同期限单位
            ,contid -- 合同id
            ,continuetime -- 连续次数
            ,contmodel -- 合同模板
            ,contractcode -- 解除劳动合同证明编号
            ,contractnum -- 合同编号
            ,conttype -- 业务类型
            ,creationtime -- 创建时间
            ,creator -- 创建人
            ,dr -- 备用DR
            ,enddate -- 合同结束日期
            ,filepath -- 上传文件路径
            ,ifprop -- 需要试用
            ,ifwrite -- 是否合同模块填写
            ,isrefer -- 是否提交
            ,judgedate -- 鉴证日期
            ,lastflag -- 是否最近记录
            ,memo -- 备注
            ,modifiedtime -- 修改时间
            ,modifier -- 修改人
            ,neconomy -- 经济补偿金
            ,pk_conttext -- 劳动合同模板
            ,pk_group -- 所属集团
            ,pk_majorcorp -- 合同主体单位
            ,pk_org -- 业务发生组织
            ,pk_psndoc -- 人员主键
            ,pk_psndoc_sub -- 合同主键
            ,pk_psnjob -- 任职主键
            ,pk_psnorg -- 组织关系主键
            ,pk_termtype -- 备用PK_TERMTYPE
            ,pk_unchreason -- 解除合同原因
            ,presenter -- 解除提出方
            ,probegindate -- 试用开始日期
            ,probenddate -- 试用结束日期
            ,probsalary -- 试用期工资
            ,promonth -- 试用期限
            ,prop_unit -- 试用期限单位
            ,recordnum -- 记录序号
            ,signaddr -- 签订地点
            ,signdate -- 业务发生日期
            ,startsalary -- 试用期满工资
            ,termmonth -- 合同期限
            ,termtype -- 合同期限类型
            ,ts -- 时间戳
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.nhrs_hi_psndoc_ctrt_op(
            assgid -- 人员任职ID
            ,begindate -- 合同开始日期
            ,breachmoney -- 赔偿金
            ,cont_unit -- 合同期限单位
            ,contid -- 合同id
            ,continuetime -- 连续次数
            ,contmodel -- 合同模板
            ,contractcode -- 解除劳动合同证明编号
            ,contractnum -- 合同编号
            ,conttype -- 业务类型
            ,creationtime -- 创建时间
            ,creator -- 创建人
            ,dr -- 备用DR
            ,enddate -- 合同结束日期
            ,filepath -- 上传文件路径
            ,ifprop -- 需要试用
            ,ifwrite -- 是否合同模块填写
            ,isrefer -- 是否提交
            ,judgedate -- 鉴证日期
            ,lastflag -- 是否最近记录
            ,memo -- 备注
            ,modifiedtime -- 修改时间
            ,modifier -- 修改人
            ,neconomy -- 经济补偿金
            ,pk_conttext -- 劳动合同模板
            ,pk_group -- 所属集团
            ,pk_majorcorp -- 合同主体单位
            ,pk_org -- 业务发生组织
            ,pk_psndoc -- 人员主键
            ,pk_psndoc_sub -- 合同主键
            ,pk_psnjob -- 任职主键
            ,pk_psnorg -- 组织关系主键
            ,pk_termtype -- 备用PK_TERMTYPE
            ,pk_unchreason -- 解除合同原因
            ,presenter -- 解除提出方
            ,probegindate -- 试用开始日期
            ,probenddate -- 试用结束日期
            ,probsalary -- 试用期工资
            ,promonth -- 试用期限
            ,prop_unit -- 试用期限单位
            ,recordnum -- 记录序号
            ,signaddr -- 签订地点
            ,signdate -- 业务发生日期
            ,startsalary -- 试用期满工资
            ,termmonth -- 合同期限
            ,termtype -- 合同期限类型
            ,ts -- 时间戳
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.assgid, o.assgid) as assgid -- 人员任职ID
    ,nvl(n.begindate, o.begindate) as begindate -- 合同开始日期
    ,nvl(n.breachmoney, o.breachmoney) as breachmoney -- 赔偿金
    ,nvl(n.cont_unit, o.cont_unit) as cont_unit -- 合同期限单位
    ,nvl(n.contid, o.contid) as contid -- 合同id
    ,nvl(n.continuetime, o.continuetime) as continuetime -- 连续次数
    ,nvl(n.contmodel, o.contmodel) as contmodel -- 合同模板
    ,nvl(n.contractcode, o.contractcode) as contractcode -- 解除劳动合同证明编号
    ,nvl(n.contractnum, o.contractnum) as contractnum -- 合同编号
    ,nvl(n.conttype, o.conttype) as conttype -- 业务类型
    ,nvl(n.creationtime, o.creationtime) as creationtime -- 创建时间
    ,nvl(n.creator, o.creator) as creator -- 创建人
    ,nvl(n.dr, o.dr) as dr -- 备用DR
    ,nvl(n.enddate, o.enddate) as enddate -- 合同结束日期
    ,nvl(n.filepath, o.filepath) as filepath -- 上传文件路径
    ,nvl(n.ifprop, o.ifprop) as ifprop -- 需要试用
    ,nvl(n.ifwrite, o.ifwrite) as ifwrite -- 是否合同模块填写
    ,nvl(n.isrefer, o.isrefer) as isrefer -- 是否提交
    ,nvl(n.judgedate, o.judgedate) as judgedate -- 鉴证日期
    ,nvl(n.lastflag, o.lastflag) as lastflag -- 是否最近记录
    ,nvl(n.memo, o.memo) as memo -- 备注
    ,nvl(n.modifiedtime, o.modifiedtime) as modifiedtime -- 修改时间
    ,nvl(n.modifier, o.modifier) as modifier -- 修改人
    ,nvl(n.neconomy, o.neconomy) as neconomy -- 经济补偿金
    ,nvl(n.pk_conttext, o.pk_conttext) as pk_conttext -- 劳动合同模板
    ,nvl(n.pk_group, o.pk_group) as pk_group -- 所属集团
    ,nvl(n.pk_majorcorp, o.pk_majorcorp) as pk_majorcorp -- 合同主体单位
    ,nvl(n.pk_org, o.pk_org) as pk_org -- 业务发生组织
    ,nvl(n.pk_psndoc, o.pk_psndoc) as pk_psndoc -- 人员主键
    ,nvl(n.pk_psndoc_sub, o.pk_psndoc_sub) as pk_psndoc_sub -- 合同主键
    ,nvl(n.pk_psnjob, o.pk_psnjob) as pk_psnjob -- 任职主键
    ,nvl(n.pk_psnorg, o.pk_psnorg) as pk_psnorg -- 组织关系主键
    ,nvl(n.pk_termtype, o.pk_termtype) as pk_termtype -- 备用PK_TERMTYPE
    ,nvl(n.pk_unchreason, o.pk_unchreason) as pk_unchreason -- 解除合同原因
    ,nvl(n.presenter, o.presenter) as presenter -- 解除提出方
    ,nvl(n.probegindate, o.probegindate) as probegindate -- 试用开始日期
    ,nvl(n.probenddate, o.probenddate) as probenddate -- 试用结束日期
    ,nvl(n.probsalary, o.probsalary) as probsalary -- 试用期工资
    ,nvl(n.promonth, o.promonth) as promonth -- 试用期限
    ,nvl(n.prop_unit, o.prop_unit) as prop_unit -- 试用期限单位
    ,nvl(n.recordnum, o.recordnum) as recordnum -- 记录序号
    ,nvl(n.signaddr, o.signaddr) as signaddr -- 签订地点
    ,nvl(n.signdate, o.signdate) as signdate -- 业务发生日期
    ,nvl(n.startsalary, o.startsalary) as startsalary -- 试用期满工资
    ,nvl(n.termmonth, o.termmonth) as termmonth -- 合同期限
    ,nvl(n.termtype, o.termtype) as termtype -- 合同期限类型
    ,nvl(n.ts, o.ts) as ts -- 时间戳
    ,case when
            n.pk_psndoc_sub is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.pk_psndoc_sub is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.pk_psndoc_sub is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.nhrs_hi_psndoc_ctrt_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.nhrs_hi_psndoc_ctrt where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.pk_psndoc_sub = n.pk_psndoc_sub
where (
        o.pk_psndoc_sub is null
    )
    or (
        n.pk_psndoc_sub is null
    )
    or (
        o.assgid <> n.assgid
        or o.begindate <> n.begindate
        or o.breachmoney <> n.breachmoney
        or o.cont_unit <> n.cont_unit
        or o.contid <> n.contid
        or o.continuetime <> n.continuetime
        or o.contmodel <> n.contmodel
        or o.contractcode <> n.contractcode
        or o.contractnum <> n.contractnum
        or o.conttype <> n.conttype
        or o.creationtime <> n.creationtime
        or o.creator <> n.creator
        or o.dr <> n.dr
        or o.enddate <> n.enddate
        or o.filepath <> n.filepath
        or o.ifprop <> n.ifprop
        or o.ifwrite <> n.ifwrite
        or o.isrefer <> n.isrefer
        or o.judgedate <> n.judgedate
        or o.lastflag <> n.lastflag
        or o.memo <> n.memo
        or o.modifiedtime <> n.modifiedtime
        or o.modifier <> n.modifier
        or o.neconomy <> n.neconomy
        or o.pk_conttext <> n.pk_conttext
        or o.pk_group <> n.pk_group
        or o.pk_majorcorp <> n.pk_majorcorp
        or o.pk_org <> n.pk_org
        or o.pk_psndoc <> n.pk_psndoc
        or o.pk_psnjob <> n.pk_psnjob
        or o.pk_psnorg <> n.pk_psnorg
        or o.pk_termtype <> n.pk_termtype
        or o.pk_unchreason <> n.pk_unchreason
        or o.presenter <> n.presenter
        or o.probegindate <> n.probegindate
        or o.probenddate <> n.probenddate
        or o.probsalary <> n.probsalary
        or o.promonth <> n.promonth
        or o.prop_unit <> n.prop_unit
        or o.recordnum <> n.recordnum
        or o.signaddr <> n.signaddr
        or o.signdate <> n.signdate
        or o.startsalary <> n.startsalary
        or o.termmonth <> n.termmonth
        or o.termtype <> n.termtype
        or o.ts <> n.ts
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.nhrs_hi_psndoc_ctrt_cl(
            assgid -- 人员任职ID
            ,begindate -- 合同开始日期
            ,breachmoney -- 赔偿金
            ,cont_unit -- 合同期限单位
            ,contid -- 合同id
            ,continuetime -- 连续次数
            ,contmodel -- 合同模板
            ,contractcode -- 解除劳动合同证明编号
            ,contractnum -- 合同编号
            ,conttype -- 业务类型
            ,creationtime -- 创建时间
            ,creator -- 创建人
            ,dr -- 备用DR
            ,enddate -- 合同结束日期
            ,filepath -- 上传文件路径
            ,ifprop -- 需要试用
            ,ifwrite -- 是否合同模块填写
            ,isrefer -- 是否提交
            ,judgedate -- 鉴证日期
            ,lastflag -- 是否最近记录
            ,memo -- 备注
            ,modifiedtime -- 修改时间
            ,modifier -- 修改人
            ,neconomy -- 经济补偿金
            ,pk_conttext -- 劳动合同模板
            ,pk_group -- 所属集团
            ,pk_majorcorp -- 合同主体单位
            ,pk_org -- 业务发生组织
            ,pk_psndoc -- 人员主键
            ,pk_psndoc_sub -- 合同主键
            ,pk_psnjob -- 任职主键
            ,pk_psnorg -- 组织关系主键
            ,pk_termtype -- 备用PK_TERMTYPE
            ,pk_unchreason -- 解除合同原因
            ,presenter -- 解除提出方
            ,probegindate -- 试用开始日期
            ,probenddate -- 试用结束日期
            ,probsalary -- 试用期工资
            ,promonth -- 试用期限
            ,prop_unit -- 试用期限单位
            ,recordnum -- 记录序号
            ,signaddr -- 签订地点
            ,signdate -- 业务发生日期
            ,startsalary -- 试用期满工资
            ,termmonth -- 合同期限
            ,termtype -- 合同期限类型
            ,ts -- 时间戳
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.nhrs_hi_psndoc_ctrt_op(
            assgid -- 人员任职ID
            ,begindate -- 合同开始日期
            ,breachmoney -- 赔偿金
            ,cont_unit -- 合同期限单位
            ,contid -- 合同id
            ,continuetime -- 连续次数
            ,contmodel -- 合同模板
            ,contractcode -- 解除劳动合同证明编号
            ,contractnum -- 合同编号
            ,conttype -- 业务类型
            ,creationtime -- 创建时间
            ,creator -- 创建人
            ,dr -- 备用DR
            ,enddate -- 合同结束日期
            ,filepath -- 上传文件路径
            ,ifprop -- 需要试用
            ,ifwrite -- 是否合同模块填写
            ,isrefer -- 是否提交
            ,judgedate -- 鉴证日期
            ,lastflag -- 是否最近记录
            ,memo -- 备注
            ,modifiedtime -- 修改时间
            ,modifier -- 修改人
            ,neconomy -- 经济补偿金
            ,pk_conttext -- 劳动合同模板
            ,pk_group -- 所属集团
            ,pk_majorcorp -- 合同主体单位
            ,pk_org -- 业务发生组织
            ,pk_psndoc -- 人员主键
            ,pk_psndoc_sub -- 合同主键
            ,pk_psnjob -- 任职主键
            ,pk_psnorg -- 组织关系主键
            ,pk_termtype -- 备用PK_TERMTYPE
            ,pk_unchreason -- 解除合同原因
            ,presenter -- 解除提出方
            ,probegindate -- 试用开始日期
            ,probenddate -- 试用结束日期
            ,probsalary -- 试用期工资
            ,promonth -- 试用期限
            ,prop_unit -- 试用期限单位
            ,recordnum -- 记录序号
            ,signaddr -- 签订地点
            ,signdate -- 业务发生日期
            ,startsalary -- 试用期满工资
            ,termmonth -- 合同期限
            ,termtype -- 合同期限类型
            ,ts -- 时间戳
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.assgid -- 人员任职ID
    ,o.begindate -- 合同开始日期
    ,o.breachmoney -- 赔偿金
    ,o.cont_unit -- 合同期限单位
    ,o.contid -- 合同id
    ,o.continuetime -- 连续次数
    ,o.contmodel -- 合同模板
    ,o.contractcode -- 解除劳动合同证明编号
    ,o.contractnum -- 合同编号
    ,o.conttype -- 业务类型
    ,o.creationtime -- 创建时间
    ,o.creator -- 创建人
    ,o.dr -- 备用DR
    ,o.enddate -- 合同结束日期
    ,o.filepath -- 上传文件路径
    ,o.ifprop -- 需要试用
    ,o.ifwrite -- 是否合同模块填写
    ,o.isrefer -- 是否提交
    ,o.judgedate -- 鉴证日期
    ,o.lastflag -- 是否最近记录
    ,o.memo -- 备注
    ,o.modifiedtime -- 修改时间
    ,o.modifier -- 修改人
    ,o.neconomy -- 经济补偿金
    ,o.pk_conttext -- 劳动合同模板
    ,o.pk_group -- 所属集团
    ,o.pk_majorcorp -- 合同主体单位
    ,o.pk_org -- 业务发生组织
    ,o.pk_psndoc -- 人员主键
    ,o.pk_psndoc_sub -- 合同主键
    ,o.pk_psnjob -- 任职主键
    ,o.pk_psnorg -- 组织关系主键
    ,o.pk_termtype -- 备用PK_TERMTYPE
    ,o.pk_unchreason -- 解除合同原因
    ,o.presenter -- 解除提出方
    ,o.probegindate -- 试用开始日期
    ,o.probenddate -- 试用结束日期
    ,o.probsalary -- 试用期工资
    ,o.promonth -- 试用期限
    ,o.prop_unit -- 试用期限单位
    ,o.recordnum -- 记录序号
    ,o.signaddr -- 签订地点
    ,o.signdate -- 业务发生日期
    ,o.startsalary -- 试用期满工资
    ,o.termmonth -- 合同期限
    ,o.termtype -- 合同期限类型
    ,o.ts -- 时间戳
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
from ${iol_schema}.nhrs_hi_psndoc_ctrt_bk o
    left join ${iol_schema}.nhrs_hi_psndoc_ctrt_op n
        on
            o.pk_psndoc_sub = n.pk_psndoc_sub
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.nhrs_hi_psndoc_ctrt_cl d
        on
            o.pk_psndoc_sub = d.pk_psndoc_sub
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.nhrs_hi_psndoc_ctrt;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('nhrs_hi_psndoc_ctrt') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.nhrs_hi_psndoc_ctrt drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.nhrs_hi_psndoc_ctrt add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.nhrs_hi_psndoc_ctrt exchange partition p_${batch_date} with table ${iol_schema}.nhrs_hi_psndoc_ctrt_cl;
alter table ${iol_schema}.nhrs_hi_psndoc_ctrt exchange partition p_20991231 with table ${iol_schema}.nhrs_hi_psndoc_ctrt_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.nhrs_hi_psndoc_ctrt to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.nhrs_hi_psndoc_ctrt_op purge;
drop table ${iol_schema}.nhrs_hi_psndoc_ctrt_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.nhrs_hi_psndoc_ctrt_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'nhrs_hi_psndoc_ctrt',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
