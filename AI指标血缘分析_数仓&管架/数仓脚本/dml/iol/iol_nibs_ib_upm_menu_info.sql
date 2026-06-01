/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_nibs_ib_upm_menu_info
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
create table ${iol_schema}.nibs_ib_upm_menu_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.nibs_ib_upm_menu_info
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.nibs_ib_upm_menu_info_op purge;
drop table ${iol_schema}.nibs_ib_upm_menu_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nibs_ib_upm_menu_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.nibs_ib_upm_menu_info where 0=1;

create table ${iol_schema}.nibs_ib_upm_menu_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.nibs_ib_upm_menu_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.nibs_ib_upm_menu_info_cl(
            appnum -- 应用编号
            ,menuviewnum -- 菜单视图编号-一级菜单
            ,menunum -- 菜单编号
            ,menuname -- 菜单名称
            ,menuicon -- 菜单图标
            ,menupath -- 菜单路径
            ,menutype -- 菜单类型 : 01 目录节点 02 交易节点 03 功能节点
            ,sortnum -- 排序号
            ,parentmenunum -- 父菜单编号 : 根节点的父节点为0
            ,isvisible -- 是否可见 : 0 不可见 1可见
            ,mainbranch -- 维护机构
            ,mainuser -- 维护用户
            ,maindate -- 维护日期
            ,maintime -- 维护时间
            ,tadpath -- 交易路径
            ,weight -- 交易权重 用来统计交易数量
            ,tranflag -- 菜单分类 0-非金融类|1-金融类|2-查询类
            ,rltflag -- 权限限制配置 0-未配置 1-配置
            ,iconactive -- 选中时的图片
            ,bankflag -- 是否离行标识：0 在行 1 离行
            ,recomdeal -- 是否推荐交易：0 是 1 否
            ,englishmenuname -- 英文名称
            ,navigationmode -- 导航模式
            ,iscommon -- 是否常用
            ,inoutviewflag -- 内部/客服-服务视图|1-内部 2-客服
            ,menumodel -- 所属模块
            ,nolowcabinet -- 不可低柜员查看|1-是 0-否
            ,personsee -- 可见人|1-代理可见 2-经办人可见 3-代理经办都可见
            ,rectificationflag -- 可发起统一冲正|1-是 0-否
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.nibs_ib_upm_menu_info_op(
            appnum -- 应用编号
            ,menuviewnum -- 菜单视图编号-一级菜单
            ,menunum -- 菜单编号
            ,menuname -- 菜单名称
            ,menuicon -- 菜单图标
            ,menupath -- 菜单路径
            ,menutype -- 菜单类型 : 01 目录节点 02 交易节点 03 功能节点
            ,sortnum -- 排序号
            ,parentmenunum -- 父菜单编号 : 根节点的父节点为0
            ,isvisible -- 是否可见 : 0 不可见 1可见
            ,mainbranch -- 维护机构
            ,mainuser -- 维护用户
            ,maindate -- 维护日期
            ,maintime -- 维护时间
            ,tadpath -- 交易路径
            ,weight -- 交易权重 用来统计交易数量
            ,tranflag -- 菜单分类 0-非金融类|1-金融类|2-查询类
            ,rltflag -- 权限限制配置 0-未配置 1-配置
            ,iconactive -- 选中时的图片
            ,bankflag -- 是否离行标识：0 在行 1 离行
            ,recomdeal -- 是否推荐交易：0 是 1 否
            ,englishmenuname -- 英文名称
            ,navigationmode -- 导航模式
            ,iscommon -- 是否常用
            ,inoutviewflag -- 内部/客服-服务视图|1-内部 2-客服
            ,menumodel -- 所属模块
            ,nolowcabinet -- 不可低柜员查看|1-是 0-否
            ,personsee -- 可见人|1-代理可见 2-经办人可见 3-代理经办都可见
            ,rectificationflag -- 可发起统一冲正|1-是 0-否
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.appnum, o.appnum) as appnum -- 应用编号
    ,nvl(n.menuviewnum, o.menuviewnum) as menuviewnum -- 菜单视图编号-一级菜单
    ,nvl(n.menunum, o.menunum) as menunum -- 菜单编号
    ,nvl(n.menuname, o.menuname) as menuname -- 菜单名称
    ,nvl(n.menuicon, o.menuicon) as menuicon -- 菜单图标
    ,nvl(n.menupath, o.menupath) as menupath -- 菜单路径
    ,nvl(n.menutype, o.menutype) as menutype -- 菜单类型 : 01 目录节点 02 交易节点 03 功能节点
    ,nvl(n.sortnum, o.sortnum) as sortnum -- 排序号
    ,nvl(n.parentmenunum, o.parentmenunum) as parentmenunum -- 父菜单编号 : 根节点的父节点为0
    ,nvl(n.isvisible, o.isvisible) as isvisible -- 是否可见 : 0 不可见 1可见
    ,nvl(n.mainbranch, o.mainbranch) as mainbranch -- 维护机构
    ,nvl(n.mainuser, o.mainuser) as mainuser -- 维护用户
    ,nvl(n.maindate, o.maindate) as maindate -- 维护日期
    ,nvl(n.maintime, o.maintime) as maintime -- 维护时间
    ,nvl(n.tadpath, o.tadpath) as tadpath -- 交易路径
    ,nvl(n.weight, o.weight) as weight -- 交易权重 用来统计交易数量
    ,nvl(n.tranflag, o.tranflag) as tranflag -- 菜单分类 0-非金融类|1-金融类|2-查询类
    ,nvl(n.rltflag, o.rltflag) as rltflag -- 权限限制配置 0-未配置 1-配置
    ,nvl(n.iconactive, o.iconactive) as iconactive -- 选中时的图片
    ,nvl(n.bankflag, o.bankflag) as bankflag -- 是否离行标识：0 在行 1 离行
    ,nvl(n.recomdeal, o.recomdeal) as recomdeal -- 是否推荐交易：0 是 1 否
    ,nvl(n.englishmenuname, o.englishmenuname) as englishmenuname -- 英文名称
    ,nvl(n.navigationmode, o.navigationmode) as navigationmode -- 导航模式
    ,nvl(n.iscommon, o.iscommon) as iscommon -- 是否常用
    ,nvl(n.inoutviewflag, o.inoutviewflag) as inoutviewflag -- 内部/客服-服务视图|1-内部 2-客服
    ,nvl(n.menumodel, o.menumodel) as menumodel -- 所属模块
    ,nvl(n.nolowcabinet, o.nolowcabinet) as nolowcabinet -- 不可低柜员查看|1-是 0-否
    ,nvl(n.personsee, o.personsee) as personsee -- 可见人|1-代理可见 2-经办人可见 3-代理经办都可见
    ,nvl(n.rectificationflag, o.rectificationflag) as rectificationflag -- 可发起统一冲正|1-是 0-否
    ,case when
            n.appnum is null
            and n.menuviewnum is null
            and n.menunum is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.appnum is null
            and n.menuviewnum is null
            and n.menunum is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.appnum is null
            and n.menuviewnum is null
            and n.menunum is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.nibs_ib_upm_menu_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.nibs_ib_upm_menu_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.appnum = n.appnum
            and o.menuviewnum = n.menuviewnum
            and o.menunum = n.menunum
where (
        o.appnum is null
        and o.menuviewnum is null
        and o.menunum is null
    )
    or (
        n.appnum is null
        and n.menuviewnum is null
        and n.menunum is null
    )
    or (
        o.menuname <> n.menuname
        or o.menuicon <> n.menuicon
        or o.menupath <> n.menupath
        or o.menutype <> n.menutype
        or o.sortnum <> n.sortnum
        or o.parentmenunum <> n.parentmenunum
        or o.isvisible <> n.isvisible
        or o.mainbranch <> n.mainbranch
        or o.mainuser <> n.mainuser
        or o.maindate <> n.maindate
        or o.maintime <> n.maintime
        or o.tadpath <> n.tadpath
        or o.weight <> n.weight
        or o.tranflag <> n.tranflag
        or o.rltflag <> n.rltflag
        or o.iconactive <> n.iconactive
        or o.bankflag <> n.bankflag
        or o.recomdeal <> n.recomdeal
        or o.englishmenuname <> n.englishmenuname
        or o.navigationmode <> n.navigationmode
        or o.iscommon <> n.iscommon
        or o.inoutviewflag <> n.inoutviewflag
        or o.menumodel <> n.menumodel
        or o.nolowcabinet <> n.nolowcabinet
        or o.personsee <> n.personsee
        or o.rectificationflag <> n.rectificationflag
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.nibs_ib_upm_menu_info_cl(
            appnum -- 应用编号
            ,menuviewnum -- 菜单视图编号-一级菜单
            ,menunum -- 菜单编号
            ,menuname -- 菜单名称
            ,menuicon -- 菜单图标
            ,menupath -- 菜单路径
            ,menutype -- 菜单类型 : 01 目录节点 02 交易节点 03 功能节点
            ,sortnum -- 排序号
            ,parentmenunum -- 父菜单编号 : 根节点的父节点为0
            ,isvisible -- 是否可见 : 0 不可见 1可见
            ,mainbranch -- 维护机构
            ,mainuser -- 维护用户
            ,maindate -- 维护日期
            ,maintime -- 维护时间
            ,tadpath -- 交易路径
            ,weight -- 交易权重 用来统计交易数量
            ,tranflag -- 菜单分类 0-非金融类|1-金融类|2-查询类
            ,rltflag -- 权限限制配置 0-未配置 1-配置
            ,iconactive -- 选中时的图片
            ,bankflag -- 是否离行标识：0 在行 1 离行
            ,recomdeal -- 是否推荐交易：0 是 1 否
            ,englishmenuname -- 英文名称
            ,navigationmode -- 导航模式
            ,iscommon -- 是否常用
            ,inoutviewflag -- 内部/客服-服务视图|1-内部 2-客服
            ,menumodel -- 所属模块
            ,nolowcabinet -- 不可低柜员查看|1-是 0-否
            ,personsee -- 可见人|1-代理可见 2-经办人可见 3-代理经办都可见
            ,rectificationflag -- 可发起统一冲正|1-是 0-否
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.nibs_ib_upm_menu_info_op(
            appnum -- 应用编号
            ,menuviewnum -- 菜单视图编号-一级菜单
            ,menunum -- 菜单编号
            ,menuname -- 菜单名称
            ,menuicon -- 菜单图标
            ,menupath -- 菜单路径
            ,menutype -- 菜单类型 : 01 目录节点 02 交易节点 03 功能节点
            ,sortnum -- 排序号
            ,parentmenunum -- 父菜单编号 : 根节点的父节点为0
            ,isvisible -- 是否可见 : 0 不可见 1可见
            ,mainbranch -- 维护机构
            ,mainuser -- 维护用户
            ,maindate -- 维护日期
            ,maintime -- 维护时间
            ,tadpath -- 交易路径
            ,weight -- 交易权重 用来统计交易数量
            ,tranflag -- 菜单分类 0-非金融类|1-金融类|2-查询类
            ,rltflag -- 权限限制配置 0-未配置 1-配置
            ,iconactive -- 选中时的图片
            ,bankflag -- 是否离行标识：0 在行 1 离行
            ,recomdeal -- 是否推荐交易：0 是 1 否
            ,englishmenuname -- 英文名称
            ,navigationmode -- 导航模式
            ,iscommon -- 是否常用
            ,inoutviewflag -- 内部/客服-服务视图|1-内部 2-客服
            ,menumodel -- 所属模块
            ,nolowcabinet -- 不可低柜员查看|1-是 0-否
            ,personsee -- 可见人|1-代理可见 2-经办人可见 3-代理经办都可见
            ,rectificationflag -- 可发起统一冲正|1-是 0-否
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.appnum -- 应用编号
    ,o.menuviewnum -- 菜单视图编号-一级菜单
    ,o.menunum -- 菜单编号
    ,o.menuname -- 菜单名称
    ,o.menuicon -- 菜单图标
    ,o.menupath -- 菜单路径
    ,o.menutype -- 菜单类型 : 01 目录节点 02 交易节点 03 功能节点
    ,o.sortnum -- 排序号
    ,o.parentmenunum -- 父菜单编号 : 根节点的父节点为0
    ,o.isvisible -- 是否可见 : 0 不可见 1可见
    ,o.mainbranch -- 维护机构
    ,o.mainuser -- 维护用户
    ,o.maindate -- 维护日期
    ,o.maintime -- 维护时间
    ,o.tadpath -- 交易路径
    ,o.weight -- 交易权重 用来统计交易数量
    ,o.tranflag -- 菜单分类 0-非金融类|1-金融类|2-查询类
    ,o.rltflag -- 权限限制配置 0-未配置 1-配置
    ,o.iconactive -- 选中时的图片
    ,o.bankflag -- 是否离行标识：0 在行 1 离行
    ,o.recomdeal -- 是否推荐交易：0 是 1 否
    ,o.englishmenuname -- 英文名称
    ,o.navigationmode -- 导航模式
    ,o.iscommon -- 是否常用
    ,o.inoutviewflag -- 内部/客服-服务视图|1-内部 2-客服
    ,o.menumodel -- 所属模块
    ,o.nolowcabinet -- 不可低柜员查看|1-是 0-否
    ,o.personsee -- 可见人|1-代理可见 2-经办人可见 3-代理经办都可见
    ,o.rectificationflag -- 可发起统一冲正|1-是 0-否
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
from ${iol_schema}.nibs_ib_upm_menu_info_bk o
    left join ${iol_schema}.nibs_ib_upm_menu_info_op n
        on
            o.appnum = n.appnum
            and o.menuviewnum = n.menuviewnum
            and o.menunum = n.menunum
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.nibs_ib_upm_menu_info_cl d
        on
            o.appnum = d.appnum
            and o.menuviewnum = d.menuviewnum
            and o.menunum = d.menunum
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.nibs_ib_upm_menu_info;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('nibs_ib_upm_menu_info') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.nibs_ib_upm_menu_info drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.nibs_ib_upm_menu_info add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.nibs_ib_upm_menu_info exchange partition p_${batch_date} with table ${iol_schema}.nibs_ib_upm_menu_info_cl;
alter table ${iol_schema}.nibs_ib_upm_menu_info exchange partition p_20991231 with table ${iol_schema}.nibs_ib_upm_menu_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.nibs_ib_upm_menu_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.nibs_ib_upm_menu_info_op purge;
drop table ${iol_schema}.nibs_ib_upm_menu_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.nibs_ib_upm_menu_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'nibs_ib_upm_menu_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
