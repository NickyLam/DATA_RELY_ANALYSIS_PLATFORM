/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol pams_jxbb_zfldspd_zjb
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.pams_jxbb_zfldspd_zjb
whenever sqlerror continue none;
drop table ${iol_schema}.pams_jxbb_zfldspd_zjb purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_jxbb_zfldspd_zjb(
    jxdxdh number(22) -- 绩效对象代号
    ,hykhdxdh number(22) -- 行员考核对象代号
    ,jgkhdxdh number(22) -- 机构考核对象代号
    ,ldpz varchar2(6) -- 联动品种
    ,zqdm varchar2(900) -- 债券代码
    ,zqmc varchar2(300) -- 债券名称
    ,zqpmll number(25,4) -- 债券票面利率
    ,tzsyl number(25,4) -- 调整收益率
    ,tzje number(25,4) -- 调整金额
    ,khh varchar2(90) -- 客户号
    ,tzfs varchar2(6) -- 调整方式
    ,dyckzh varchar2(4000) -- 对应存款账号
    ,xnh varchar2(120) -- 虚拟户
    ,tjrq number(22) -- 统计日期（即创建日期
    ,qx varchar2(30) -- 期限
    ,zyr number(22) -- 质押日
    ,dqr number(22) -- 到期日
    ,ckje number(25,4) -- 存款金额
    ,zyzqlx varchar2(6) -- 质押债券类型
    ,zyzqje number(25,4) -- 质押债券金额
    ,spzt varchar2(6) -- 审批状态
    ,spdh varchar2(96) -- 审批代号
    ,tzsj timestamp -- 调整时间(审批流的开始时间)
    ,ldywlx varchar2(6) -- 联动业务类型（区分债券和质押）
    ,fsfs varchar2(6) -- 发生方式
    ,tzrq number(22) -- 发生调整的日期
    ,sxrq number(22) -- 生效日期
    ,sjzt varchar2(6) -- 数据状态
    ,taskid varchar2(180) -- OA待办任务ID
    ,auditid number(22) -- 实际审批人
    ,jsrq number(22) -- 结束日期
    ,hth varchar2(300) -- 合同号
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
grant select on ${iol_schema}.pams_jxbb_zfldspd_zjb to ${iml_schema};
grant select on ${iol_schema}.pams_jxbb_zfldspd_zjb to ${icl_schema};
grant select on ${iol_schema}.pams_jxbb_zfldspd_zjb to ${idl_schema};
grant select on ${iol_schema}.pams_jxbb_zfldspd_zjb to ${iel_schema};

-- comment
comment on table ${iol_schema}.pams_jxbb_zfldspd_zjb is '绩效报表_总分联动审批单_资金部';
comment on column ${iol_schema}.pams_jxbb_zfldspd_zjb.jxdxdh is '绩效对象代号';
comment on column ${iol_schema}.pams_jxbb_zfldspd_zjb.hykhdxdh is '行员考核对象代号';
comment on column ${iol_schema}.pams_jxbb_zfldspd_zjb.jgkhdxdh is '机构考核对象代号';
comment on column ${iol_schema}.pams_jxbb_zfldspd_zjb.ldpz is '联动品种';
comment on column ${iol_schema}.pams_jxbb_zfldspd_zjb.zqdm is '债券代码';
comment on column ${iol_schema}.pams_jxbb_zfldspd_zjb.zqmc is '债券名称';
comment on column ${iol_schema}.pams_jxbb_zfldspd_zjb.zqpmll is '债券票面利率';
comment on column ${iol_schema}.pams_jxbb_zfldspd_zjb.tzsyl is '调整收益率';
comment on column ${iol_schema}.pams_jxbb_zfldspd_zjb.tzje is '调整金额';
comment on column ${iol_schema}.pams_jxbb_zfldspd_zjb.khh is '客户号';
comment on column ${iol_schema}.pams_jxbb_zfldspd_zjb.tzfs is '调整方式';
comment on column ${iol_schema}.pams_jxbb_zfldspd_zjb.dyckzh is '对应存款账号';
comment on column ${iol_schema}.pams_jxbb_zfldspd_zjb.xnh is '虚拟户';
comment on column ${iol_schema}.pams_jxbb_zfldspd_zjb.tjrq is '统计日期（即创建日期';
comment on column ${iol_schema}.pams_jxbb_zfldspd_zjb.qx is '期限';
comment on column ${iol_schema}.pams_jxbb_zfldspd_zjb.zyr is '质押日';
comment on column ${iol_schema}.pams_jxbb_zfldspd_zjb.dqr is '到期日';
comment on column ${iol_schema}.pams_jxbb_zfldspd_zjb.ckje is '存款金额';
comment on column ${iol_schema}.pams_jxbb_zfldspd_zjb.zyzqlx is '质押债券类型';
comment on column ${iol_schema}.pams_jxbb_zfldspd_zjb.zyzqje is '质押债券金额';
comment on column ${iol_schema}.pams_jxbb_zfldspd_zjb.spzt is '审批状态';
comment on column ${iol_schema}.pams_jxbb_zfldspd_zjb.spdh is '审批代号';
comment on column ${iol_schema}.pams_jxbb_zfldspd_zjb.tzsj is '调整时间(审批流的开始时间)';
comment on column ${iol_schema}.pams_jxbb_zfldspd_zjb.ldywlx is '联动业务类型（区分债券和质押）';
comment on column ${iol_schema}.pams_jxbb_zfldspd_zjb.fsfs is '发生方式';
comment on column ${iol_schema}.pams_jxbb_zfldspd_zjb.tzrq is '发生调整的日期';
comment on column ${iol_schema}.pams_jxbb_zfldspd_zjb.sxrq is '生效日期';
comment on column ${iol_schema}.pams_jxbb_zfldspd_zjb.sjzt is '数据状态';
comment on column ${iol_schema}.pams_jxbb_zfldspd_zjb.taskid is 'OA待办任务ID';
comment on column ${iol_schema}.pams_jxbb_zfldspd_zjb.auditid is '实际审批人';
comment on column ${iol_schema}.pams_jxbb_zfldspd_zjb.jsrq is '结束日期';
comment on column ${iol_schema}.pams_jxbb_zfldspd_zjb.hth is '合同号';
comment on column ${iol_schema}.pams_jxbb_zfldspd_zjb.start_dt is '开始时间';
comment on column ${iol_schema}.pams_jxbb_zfldspd_zjb.end_dt is '结束时间';
comment on column ${iol_schema}.pams_jxbb_zfldspd_zjb.id_mark is '增删标志';
comment on column ${iol_schema}.pams_jxbb_zfldspd_zjb.etl_timestamp is 'ETL处理时间戳';
