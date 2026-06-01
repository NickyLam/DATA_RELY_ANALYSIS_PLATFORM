/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol nibs_ib_upm_menu_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.nibs_ib_upm_menu_info
whenever sqlerror continue none;
drop table ${iol_schema}.nibs_ib_upm_menu_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nibs_ib_upm_menu_info(
    appnum varchar2(16) -- 应用编号
    ,menuviewnum varchar2(12) -- 菜单视图编号-一级菜单
    ,menunum varchar2(50) -- 菜单编号
    ,menuname varchar2(128) -- 菜单名称
    ,menuicon varchar2(128) -- 菜单图标
    ,menupath varchar2(128) -- 菜单路径
    ,menutype varchar2(2) -- 菜单类型 : 01 目录节点 02 交易节点 03 功能节点
    ,sortnum varchar2(10) -- 排序号
    ,parentmenunum varchar2(20) -- 父菜单编号 : 根节点的父节点为0
    ,isvisible varchar2(5) -- 是否可见 : 0 不可见 1可见
    ,mainbranch varchar2(10) -- 维护机构
    ,mainuser varchar2(12) -- 维护用户
    ,maindate varchar2(10) -- 维护日期
    ,maintime varchar2(8) -- 维护时间
    ,tadpath varchar2(120) -- 交易路径
    ,weight varchar2(20) -- 交易权重 用来统计交易数量
    ,tranflag varchar2(1) -- 菜单分类 0-非金融类|1-金融类|2-查询类
    ,rltflag varchar2(2) -- 权限限制配置 0-未配置 1-配置
    ,iconactive varchar2(200) -- 选中时的图片
    ,bankflag varchar2(10) -- 是否离行标识：0 在行 1 离行
    ,recomdeal varchar2(10) -- 是否推荐交易：0 是 1 否
    ,englishmenuname varchar2(100) -- 英文名称
    ,navigationmode varchar2(100) -- 导航模式
    ,iscommon varchar2(100) -- 是否常用
    ,inoutviewflag varchar2(10) -- 内部/客服-服务视图|1-内部 2-客服
    ,menumodel varchar2(100) -- 所属模块
    ,nolowcabinet varchar2(10) -- 不可低柜员查看|1-是 0-否
    ,personsee varchar2(10) -- 可见人|1-代理可见 2-经办人可见 3-代理经办都可见
    ,rectificationflag varchar2(10) -- 可发起统一冲正|1-是 0-否
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(end_dt)(
     partition p_19000101 values (to_date('19000101','yyyymmdd')),
     partition p_20991231 values (to_date('20991231','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.nibs_ib_upm_menu_info to ${iml_schema};
grant select on ${iol_schema}.nibs_ib_upm_menu_info to ${icl_schema};
grant select on ${iol_schema}.nibs_ib_upm_menu_info to ${idl_schema};
grant select on ${iol_schema}.nibs_ib_upm_menu_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.nibs_ib_upm_menu_info is '交易菜单表';
comment on column ${iol_schema}.nibs_ib_upm_menu_info.appnum is '应用编号';
comment on column ${iol_schema}.nibs_ib_upm_menu_info.menuviewnum is '菜单视图编号-一级菜单';
comment on column ${iol_schema}.nibs_ib_upm_menu_info.menunum is '菜单编号';
comment on column ${iol_schema}.nibs_ib_upm_menu_info.menuname is '菜单名称';
comment on column ${iol_schema}.nibs_ib_upm_menu_info.menuicon is '菜单图标';
comment on column ${iol_schema}.nibs_ib_upm_menu_info.menupath is '菜单路径';
comment on column ${iol_schema}.nibs_ib_upm_menu_info.menutype is '菜单类型 : 01 目录节点 02 交易节点 03 功能节点';
comment on column ${iol_schema}.nibs_ib_upm_menu_info.sortnum is '排序号';
comment on column ${iol_schema}.nibs_ib_upm_menu_info.parentmenunum is '父菜单编号 : 根节点的父节点为0';
comment on column ${iol_schema}.nibs_ib_upm_menu_info.isvisible is '是否可见 : 0 不可见 1可见';
comment on column ${iol_schema}.nibs_ib_upm_menu_info.mainbranch is '维护机构';
comment on column ${iol_schema}.nibs_ib_upm_menu_info.mainuser is '维护用户';
comment on column ${iol_schema}.nibs_ib_upm_menu_info.maindate is '维护日期';
comment on column ${iol_schema}.nibs_ib_upm_menu_info.maintime is '维护时间';
comment on column ${iol_schema}.nibs_ib_upm_menu_info.tadpath is '交易路径';
comment on column ${iol_schema}.nibs_ib_upm_menu_info.weight is '交易权重 用来统计交易数量';
comment on column ${iol_schema}.nibs_ib_upm_menu_info.tranflag is '菜单分类 0-非金融类|1-金融类|2-查询类';
comment on column ${iol_schema}.nibs_ib_upm_menu_info.rltflag is '权限限制配置 0-未配置 1-配置';
comment on column ${iol_schema}.nibs_ib_upm_menu_info.iconactive is '选中时的图片';
comment on column ${iol_schema}.nibs_ib_upm_menu_info.bankflag is '是否离行标识：0 在行 1 离行';
comment on column ${iol_schema}.nibs_ib_upm_menu_info.recomdeal is '是否推荐交易：0 是 1 否';
comment on column ${iol_schema}.nibs_ib_upm_menu_info.englishmenuname is '英文名称';
comment on column ${iol_schema}.nibs_ib_upm_menu_info.navigationmode is '导航模式';
comment on column ${iol_schema}.nibs_ib_upm_menu_info.iscommon is '是否常用';
comment on column ${iol_schema}.nibs_ib_upm_menu_info.inoutviewflag is '内部/客服-服务视图|1-内部 2-客服';
comment on column ${iol_schema}.nibs_ib_upm_menu_info.menumodel is '所属模块';
comment on column ${iol_schema}.nibs_ib_upm_menu_info.nolowcabinet is '不可低柜员查看|1-是 0-否';
comment on column ${iol_schema}.nibs_ib_upm_menu_info.personsee is '可见人|1-代理可见 2-经办人可见 3-代理经办都可见';
comment on column ${iol_schema}.nibs_ib_upm_menu_info.rectificationflag is '可发起统一冲正|1-是 0-否';
comment on column ${iol_schema}.nibs_ib_upm_menu_info.start_dt is '开始时间';
comment on column ${iol_schema}.nibs_ib_upm_menu_info.end_dt is '结束时间';
comment on column ${iol_schema}.nibs_ib_upm_menu_info.id_mark is '增删标志';
comment on column ${iol_schema}.nibs_ib_upm_menu_info.etl_timestamp is 'ETL处理时间戳';
