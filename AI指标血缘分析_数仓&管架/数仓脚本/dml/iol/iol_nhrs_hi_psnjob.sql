/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_nhrs_hi_psnjob
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
create table ${iol_schema}.nhrs_hi_psnjob_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.nhrs_hi_psnjob
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.nhrs_hi_psnjob_op purge;
drop table ${iol_schema}.nhrs_hi_psnjob_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nhrs_hi_psnjob_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.nhrs_hi_psnjob where 0=1;

create table ${iol_schema}.nhrs_hi_psnjob_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.nhrs_hi_psnjob where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.nhrs_hi_psnjob_cl(
            assgid -- 人员任职ID
            ,begindate -- 开始日期
            ,clerkcode -- 员工号
            ,creationtime -- 创建时间
            ,creator -- 创建人
            ,dataoriginflag -- 分布式
            ,deposemode -- 免职方式
            ,dr -- 备用DR
            ,enddate -- 结束日期
            ,endflag -- 是否结束
            ,ismainjob -- 是否主职
            ,jobmode -- 任职方式
            ,lastflag -- 最新记录
            ,memo -- 备注
            ,modifiedtime -- 修改时间
            ,modifier -- 修改人
            ,occupation -- 职业
            ,oribillpk -- 来源单据主键
            ,oribilltype -- 来源单据类型
            ,pk_dept -- 部门
            ,pk_dept_v -- 部门版本信息
            ,pk_group -- 集团
            ,pk_hrgroup -- 所属集团
            ,pk_hrorg -- 人力资源组织
            ,pk_job -- 职务
            ,pk_job_type -- 任职类型
            ,pk_jobgrade -- 职级
            ,pk_jobrank -- 职等
            ,pk_org -- 组织
            ,pk_org_v -- 组织版本信息
            ,pk_post -- 岗位
            ,pk_postseries -- 岗位序列
            ,pk_psncl -- 人员类别
            ,pk_psndoc -- 人员
            ,pk_psnjob -- 工作记录
            ,pk_psnorg -- 组织关系主键
            ,poststat -- 是否在岗
            ,psntype -- 人员类型
            ,recordnum -- 记录序号
            ,series -- 职务类别
            ,showorder -- 人员顺序号
            ,trial_flag -- 是否试用
            ,trial_type -- 试用类型
            ,trnsevent -- 异动事件
            ,trnsreason -- 异动原因
            ,trnstype -- 异动类型
            ,ts -- 时间戳
            ,worktype -- 工种
            ,jobglbdef1 -- 办公地点及楼层
            ,jobglbdef2 -- 员工层级
            ,jobglbdef3 -- 是否本部办公
            ,jobglbdef4 -- 是否为市场人员
            ,jobglbdef5 -- 是否为管理人员
            ,jobglbdef6 -- 是否清交完成
            ,jobglbdef9 -- 费用核算部门
            ,jobglbdef7 -- 兼职费用核算部门
            ,jobglbdef8 -- 兼职费用核算部门
            ,jobglbdef10 -- 职务大类
            ,jobglbdef11 -- 清缴完成日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.nhrs_hi_psnjob_op(
            assgid -- 人员任职ID
            ,begindate -- 开始日期
            ,clerkcode -- 员工号
            ,creationtime -- 创建时间
            ,creator -- 创建人
            ,dataoriginflag -- 分布式
            ,deposemode -- 免职方式
            ,dr -- 备用DR
            ,enddate -- 结束日期
            ,endflag -- 是否结束
            ,ismainjob -- 是否主职
            ,jobmode -- 任职方式
            ,lastflag -- 最新记录
            ,memo -- 备注
            ,modifiedtime -- 修改时间
            ,modifier -- 修改人
            ,occupation -- 职业
            ,oribillpk -- 来源单据主键
            ,oribilltype -- 来源单据类型
            ,pk_dept -- 部门
            ,pk_dept_v -- 部门版本信息
            ,pk_group -- 集团
            ,pk_hrgroup -- 所属集团
            ,pk_hrorg -- 人力资源组织
            ,pk_job -- 职务
            ,pk_job_type -- 任职类型
            ,pk_jobgrade -- 职级
            ,pk_jobrank -- 职等
            ,pk_org -- 组织
            ,pk_org_v -- 组织版本信息
            ,pk_post -- 岗位
            ,pk_postseries -- 岗位序列
            ,pk_psncl -- 人员类别
            ,pk_psndoc -- 人员
            ,pk_psnjob -- 工作记录
            ,pk_psnorg -- 组织关系主键
            ,poststat -- 是否在岗
            ,psntype -- 人员类型
            ,recordnum -- 记录序号
            ,series -- 职务类别
            ,showorder -- 人员顺序号
            ,trial_flag -- 是否试用
            ,trial_type -- 试用类型
            ,trnsevent -- 异动事件
            ,trnsreason -- 异动原因
            ,trnstype -- 异动类型
            ,ts -- 时间戳
            ,worktype -- 工种
            ,jobglbdef1 -- 办公地点及楼层
            ,jobglbdef2 -- 员工层级
            ,jobglbdef3 -- 是否本部办公
            ,jobglbdef4 -- 是否为市场人员
            ,jobglbdef5 -- 是否为管理人员
            ,jobglbdef6 -- 是否清交完成
            ,jobglbdef9 -- 费用核算部门
            ,jobglbdef7 -- 兼职费用核算部门
            ,jobglbdef8 -- 兼职费用核算部门
            ,jobglbdef10 -- 职务大类
            ,jobglbdef11 -- 清缴完成日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.assgid, o.assgid) as assgid -- 人员任职ID
    ,nvl(n.begindate, o.begindate) as begindate -- 开始日期
    ,nvl(n.clerkcode, o.clerkcode) as clerkcode -- 员工号
    ,nvl(n.creationtime, o.creationtime) as creationtime -- 创建时间
    ,nvl(n.creator, o.creator) as creator -- 创建人
    ,nvl(n.dataoriginflag, o.dataoriginflag) as dataoriginflag -- 分布式
    ,nvl(n.deposemode, o.deposemode) as deposemode -- 免职方式
    ,nvl(n.dr, o.dr) as dr -- 备用DR
    ,nvl(n.enddate, o.enddate) as enddate -- 结束日期
    ,nvl(n.endflag, o.endflag) as endflag -- 是否结束
    ,nvl(n.ismainjob, o.ismainjob) as ismainjob -- 是否主职
    ,nvl(n.jobmode, o.jobmode) as jobmode -- 任职方式
    ,nvl(n.lastflag, o.lastflag) as lastflag -- 最新记录
    ,nvl(n.memo, o.memo) as memo -- 备注
    ,nvl(n.modifiedtime, o.modifiedtime) as modifiedtime -- 修改时间
    ,nvl(n.modifier, o.modifier) as modifier -- 修改人
    ,nvl(n.occupation, o.occupation) as occupation -- 职业
    ,nvl(n.oribillpk, o.oribillpk) as oribillpk -- 来源单据主键
    ,nvl(n.oribilltype, o.oribilltype) as oribilltype -- 来源单据类型
    ,nvl(n.pk_dept, o.pk_dept) as pk_dept -- 部门
    ,nvl(n.pk_dept_v, o.pk_dept_v) as pk_dept_v -- 部门版本信息
    ,nvl(n.pk_group, o.pk_group) as pk_group -- 集团
    ,nvl(n.pk_hrgroup, o.pk_hrgroup) as pk_hrgroup -- 所属集团
    ,nvl(n.pk_hrorg, o.pk_hrorg) as pk_hrorg -- 人力资源组织
    ,nvl(n.pk_job, o.pk_job) as pk_job -- 职务
    ,nvl(n.pk_job_type, o.pk_job_type) as pk_job_type -- 任职类型
    ,nvl(n.pk_jobgrade, o.pk_jobgrade) as pk_jobgrade -- 职级
    ,nvl(n.pk_jobrank, o.pk_jobrank) as pk_jobrank -- 职等
    ,nvl(n.pk_org, o.pk_org) as pk_org -- 组织
    ,nvl(n.pk_org_v, o.pk_org_v) as pk_org_v -- 组织版本信息
    ,nvl(n.pk_post, o.pk_post) as pk_post -- 岗位
    ,nvl(n.pk_postseries, o.pk_postseries) as pk_postseries -- 岗位序列
    ,nvl(n.pk_psncl, o.pk_psncl) as pk_psncl -- 人员类别
    ,nvl(n.pk_psndoc, o.pk_psndoc) as pk_psndoc -- 人员
    ,nvl(n.pk_psnjob, o.pk_psnjob) as pk_psnjob -- 工作记录
    ,nvl(n.pk_psnorg, o.pk_psnorg) as pk_psnorg -- 组织关系主键
    ,nvl(n.poststat, o.poststat) as poststat -- 是否在岗
    ,nvl(n.psntype, o.psntype) as psntype -- 人员类型
    ,nvl(n.recordnum, o.recordnum) as recordnum -- 记录序号
    ,nvl(n.series, o.series) as series -- 职务类别
    ,nvl(n.showorder, o.showorder) as showorder -- 人员顺序号
    ,nvl(n.trial_flag, o.trial_flag) as trial_flag -- 是否试用
    ,nvl(n.trial_type, o.trial_type) as trial_type -- 试用类型
    ,nvl(n.trnsevent, o.trnsevent) as trnsevent -- 异动事件
    ,nvl(n.trnsreason, o.trnsreason) as trnsreason -- 异动原因
    ,nvl(n.trnstype, o.trnstype) as trnstype -- 异动类型
    ,nvl(n.ts, o.ts) as ts -- 时间戳
    ,nvl(n.worktype, o.worktype) as worktype -- 工种
    ,nvl(n.jobglbdef1, o.jobglbdef1) as jobglbdef1 -- 办公地点及楼层
    ,nvl(n.jobglbdef2, o.jobglbdef2) as jobglbdef2 -- 员工层级
    ,nvl(n.jobglbdef3, o.jobglbdef3) as jobglbdef3 -- 是否本部办公
    ,nvl(n.jobglbdef4, o.jobglbdef4) as jobglbdef4 -- 是否为市场人员
    ,nvl(n.jobglbdef5, o.jobglbdef5) as jobglbdef5 -- 是否为管理人员
    ,nvl(n.jobglbdef6, o.jobglbdef6) as jobglbdef6 -- 是否清交完成
    ,nvl(n.jobglbdef9, o.jobglbdef9) as jobglbdef9 -- 费用核算部门
    ,nvl(n.jobglbdef7, o.jobglbdef7) as jobglbdef7 -- 兼职费用核算部门
    ,nvl(n.jobglbdef8, o.jobglbdef8) as jobglbdef8 -- 兼职费用核算部门
    ,nvl(n.jobglbdef10, o.jobglbdef10) as jobglbdef10 -- 职务大类
    ,nvl(n.jobglbdef11, o.jobglbdef11) as jobglbdef11 -- 清缴完成日期
    ,case when
            n.pk_psnjob is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.pk_psnjob is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.pk_psnjob is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.nhrs_hi_psnjob_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.nhrs_hi_psnjob where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.pk_psnjob = n.pk_psnjob
where (
        o.pk_psnjob is null
    )
    or (
        n.pk_psnjob is null
    )
    or (
        o.assgid <> n.assgid
        or o.begindate <> n.begindate
        or o.clerkcode <> n.clerkcode
        or o.creationtime <> n.creationtime
        or o.creator <> n.creator
        or o.dataoriginflag <> n.dataoriginflag
        or o.deposemode <> n.deposemode
        or o.dr <> n.dr
        or o.enddate <> n.enddate
        or o.endflag <> n.endflag
        or o.ismainjob <> n.ismainjob
        or o.jobmode <> n.jobmode
        or o.lastflag <> n.lastflag
        or o.memo <> n.memo
        or o.modifiedtime <> n.modifiedtime
        or o.modifier <> n.modifier
        or o.occupation <> n.occupation
        or o.oribillpk <> n.oribillpk
        or o.oribilltype <> n.oribilltype
        or o.pk_dept <> n.pk_dept
        or o.pk_dept_v <> n.pk_dept_v
        or o.pk_group <> n.pk_group
        or o.pk_hrgroup <> n.pk_hrgroup
        or o.pk_hrorg <> n.pk_hrorg
        or o.pk_job <> n.pk_job
        or o.pk_job_type <> n.pk_job_type
        or o.pk_jobgrade <> n.pk_jobgrade
        or o.pk_jobrank <> n.pk_jobrank
        or o.pk_org <> n.pk_org
        or o.pk_org_v <> n.pk_org_v
        or o.pk_post <> n.pk_post
        or o.pk_postseries <> n.pk_postseries
        or o.pk_psncl <> n.pk_psncl
        or o.pk_psndoc <> n.pk_psndoc
        or o.pk_psnorg <> n.pk_psnorg
        or o.poststat <> n.poststat
        or o.psntype <> n.psntype
        or o.recordnum <> n.recordnum
        or o.series <> n.series
        or o.showorder <> n.showorder
        or o.trial_flag <> n.trial_flag
        or o.trial_type <> n.trial_type
        or o.trnsevent <> n.trnsevent
        or o.trnsreason <> n.trnsreason
        or o.trnstype <> n.trnstype
        or o.ts <> n.ts
        or o.worktype <> n.worktype
        or o.jobglbdef1 <> n.jobglbdef1
        or o.jobglbdef2 <> n.jobglbdef2
        or o.jobglbdef3 <> n.jobglbdef3
        or o.jobglbdef4 <> n.jobglbdef4
        or o.jobglbdef5 <> n.jobglbdef5
        or o.jobglbdef6 <> n.jobglbdef6
        or o.jobglbdef9 <> n.jobglbdef9
        or o.jobglbdef7 <> n.jobglbdef7
        or o.jobglbdef8 <> n.jobglbdef8
        or o.jobglbdef10 <> n.jobglbdef10
        or o.jobglbdef11 <> n.jobglbdef11
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.nhrs_hi_psnjob_cl(
            assgid -- 人员任职ID
            ,begindate -- 开始日期
            ,clerkcode -- 员工号
            ,creationtime -- 创建时间
            ,creator -- 创建人
            ,dataoriginflag -- 分布式
            ,deposemode -- 免职方式
            ,dr -- 备用DR
            ,enddate -- 结束日期
            ,endflag -- 是否结束
            ,ismainjob -- 是否主职
            ,jobmode -- 任职方式
            ,lastflag -- 最新记录
            ,memo -- 备注
            ,modifiedtime -- 修改时间
            ,modifier -- 修改人
            ,occupation -- 职业
            ,oribillpk -- 来源单据主键
            ,oribilltype -- 来源单据类型
            ,pk_dept -- 部门
            ,pk_dept_v -- 部门版本信息
            ,pk_group -- 集团
            ,pk_hrgroup -- 所属集团
            ,pk_hrorg -- 人力资源组织
            ,pk_job -- 职务
            ,pk_job_type -- 任职类型
            ,pk_jobgrade -- 职级
            ,pk_jobrank -- 职等
            ,pk_org -- 组织
            ,pk_org_v -- 组织版本信息
            ,pk_post -- 岗位
            ,pk_postseries -- 岗位序列
            ,pk_psncl -- 人员类别
            ,pk_psndoc -- 人员
            ,pk_psnjob -- 工作记录
            ,pk_psnorg -- 组织关系主键
            ,poststat -- 是否在岗
            ,psntype -- 人员类型
            ,recordnum -- 记录序号
            ,series -- 职务类别
            ,showorder -- 人员顺序号
            ,trial_flag -- 是否试用
            ,trial_type -- 试用类型
            ,trnsevent -- 异动事件
            ,trnsreason -- 异动原因
            ,trnstype -- 异动类型
            ,ts -- 时间戳
            ,worktype -- 工种
            ,jobglbdef1 -- 办公地点及楼层
            ,jobglbdef2 -- 员工层级
            ,jobglbdef3 -- 是否本部办公
            ,jobglbdef4 -- 是否为市场人员
            ,jobglbdef5 -- 是否为管理人员
            ,jobglbdef6 -- 是否清交完成
            ,jobglbdef9 -- 费用核算部门
            ,jobglbdef7 -- 兼职费用核算部门
            ,jobglbdef8 -- 兼职费用核算部门
            ,jobglbdef10 -- 职务大类
            ,jobglbdef11 -- 清缴完成日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.nhrs_hi_psnjob_op(
            assgid -- 人员任职ID
            ,begindate -- 开始日期
            ,clerkcode -- 员工号
            ,creationtime -- 创建时间
            ,creator -- 创建人
            ,dataoriginflag -- 分布式
            ,deposemode -- 免职方式
            ,dr -- 备用DR
            ,enddate -- 结束日期
            ,endflag -- 是否结束
            ,ismainjob -- 是否主职
            ,jobmode -- 任职方式
            ,lastflag -- 最新记录
            ,memo -- 备注
            ,modifiedtime -- 修改时间
            ,modifier -- 修改人
            ,occupation -- 职业
            ,oribillpk -- 来源单据主键
            ,oribilltype -- 来源单据类型
            ,pk_dept -- 部门
            ,pk_dept_v -- 部门版本信息
            ,pk_group -- 集团
            ,pk_hrgroup -- 所属集团
            ,pk_hrorg -- 人力资源组织
            ,pk_job -- 职务
            ,pk_job_type -- 任职类型
            ,pk_jobgrade -- 职级
            ,pk_jobrank -- 职等
            ,pk_org -- 组织
            ,pk_org_v -- 组织版本信息
            ,pk_post -- 岗位
            ,pk_postseries -- 岗位序列
            ,pk_psncl -- 人员类别
            ,pk_psndoc -- 人员
            ,pk_psnjob -- 工作记录
            ,pk_psnorg -- 组织关系主键
            ,poststat -- 是否在岗
            ,psntype -- 人员类型
            ,recordnum -- 记录序号
            ,series -- 职务类别
            ,showorder -- 人员顺序号
            ,trial_flag -- 是否试用
            ,trial_type -- 试用类型
            ,trnsevent -- 异动事件
            ,trnsreason -- 异动原因
            ,trnstype -- 异动类型
            ,ts -- 时间戳
            ,worktype -- 工种
            ,jobglbdef1 -- 办公地点及楼层
            ,jobglbdef2 -- 员工层级
            ,jobglbdef3 -- 是否本部办公
            ,jobglbdef4 -- 是否为市场人员
            ,jobglbdef5 -- 是否为管理人员
            ,jobglbdef6 -- 是否清交完成
            ,jobglbdef9 -- 费用核算部门
            ,jobglbdef7 -- 兼职费用核算部门
            ,jobglbdef8 -- 兼职费用核算部门
            ,jobglbdef10 -- 职务大类
            ,jobglbdef11 -- 清缴完成日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.assgid -- 人员任职ID
    ,o.begindate -- 开始日期
    ,o.clerkcode -- 员工号
    ,o.creationtime -- 创建时间
    ,o.creator -- 创建人
    ,o.dataoriginflag -- 分布式
    ,o.deposemode -- 免职方式
    ,o.dr -- 备用DR
    ,o.enddate -- 结束日期
    ,o.endflag -- 是否结束
    ,o.ismainjob -- 是否主职
    ,o.jobmode -- 任职方式
    ,o.lastflag -- 最新记录
    ,o.memo -- 备注
    ,o.modifiedtime -- 修改时间
    ,o.modifier -- 修改人
    ,o.occupation -- 职业
    ,o.oribillpk -- 来源单据主键
    ,o.oribilltype -- 来源单据类型
    ,o.pk_dept -- 部门
    ,o.pk_dept_v -- 部门版本信息
    ,o.pk_group -- 集团
    ,o.pk_hrgroup -- 所属集团
    ,o.pk_hrorg -- 人力资源组织
    ,o.pk_job -- 职务
    ,o.pk_job_type -- 任职类型
    ,o.pk_jobgrade -- 职级
    ,o.pk_jobrank -- 职等
    ,o.pk_org -- 组织
    ,o.pk_org_v -- 组织版本信息
    ,o.pk_post -- 岗位
    ,o.pk_postseries -- 岗位序列
    ,o.pk_psncl -- 人员类别
    ,o.pk_psndoc -- 人员
    ,o.pk_psnjob -- 工作记录
    ,o.pk_psnorg -- 组织关系主键
    ,o.poststat -- 是否在岗
    ,o.psntype -- 人员类型
    ,o.recordnum -- 记录序号
    ,o.series -- 职务类别
    ,o.showorder -- 人员顺序号
    ,o.trial_flag -- 是否试用
    ,o.trial_type -- 试用类型
    ,o.trnsevent -- 异动事件
    ,o.trnsreason -- 异动原因
    ,o.trnstype -- 异动类型
    ,o.ts -- 时间戳
    ,o.worktype -- 工种
    ,o.jobglbdef1 -- 办公地点及楼层
    ,o.jobglbdef2 -- 员工层级
    ,o.jobglbdef3 -- 是否本部办公
    ,o.jobglbdef4 -- 是否为市场人员
    ,o.jobglbdef5 -- 是否为管理人员
    ,o.jobglbdef6 -- 是否清交完成
    ,o.jobglbdef9 -- 费用核算部门
    ,o.jobglbdef7 -- 兼职费用核算部门
    ,o.jobglbdef8 -- 兼职费用核算部门
    ,o.jobglbdef10 -- 职务大类
    ,o.jobglbdef11 -- 清缴完成日期
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
from ${iol_schema}.nhrs_hi_psnjob_bk o
    left join ${iol_schema}.nhrs_hi_psnjob_op n
        on
            o.pk_psnjob = n.pk_psnjob
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.nhrs_hi_psnjob_cl d
        on
            o.pk_psnjob = d.pk_psnjob
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.nhrs_hi_psnjob;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('nhrs_hi_psnjob') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.nhrs_hi_psnjob drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.nhrs_hi_psnjob add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.nhrs_hi_psnjob exchange partition p_${batch_date} with table ${iol_schema}.nhrs_hi_psnjob_cl;
alter table ${iol_schema}.nhrs_hi_psnjob exchange partition p_20991231 with table ${iol_schema}.nhrs_hi_psnjob_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.nhrs_hi_psnjob to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.nhrs_hi_psnjob_op purge;
drop table ${iol_schema}.nhrs_hi_psnjob_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.nhrs_hi_psnjob_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'nhrs_hi_psnjob',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
