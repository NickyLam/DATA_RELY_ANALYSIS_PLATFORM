/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol pams_nbzz_dklrmx
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.pams_nbzz_dklrmx
whenever sqlerror continue none;
drop table ${iol_schema}.pams_nbzz_dklrmx purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_nbzz_dklrmx(
    tjrq number(22) -- 统计日期
    ,khdxdh number(22) -- 考核对象代号
    ,jxdxdh number(22) -- 绩效对象代号
    ,jgkhdxdh number(22) -- 机构考核对象代号
    ,kmh varchar2(30) -- 科目号
    ,cph varchar2(30) -- 产品号
    ,ywpz varchar2(30) -- 业务品种
    ,fpjs varchar2(3) -- 分配角色：1-共管，2-管户
    ,zhdh varchar2(60) -- 账户代号
    ,zzh varchar2(150) -- 子账号
    ,zhhm varchar2(150) -- 账户名称
    ,khh varchar2(45) -- 客户号
    ,jgdh varchar2(15) -- 机构代号
    ,qx varchar2(6) -- 期限
    ,zhbs varchar2(2) -- 账户标识：1-公司，2-个人
    ,bz varchar2(5) -- 币种
    ,nll number(15,7) -- 年利率
    ,zyjg number(15,7) -- 转移价格
    ,ftplc number(15,7) -- FTP利差
    ,zlbl number(19,5) -- 增量比例：大于0为当前认领，为0为历史认领
    ,zhye number(25,4) -- 账户余额
    ,hyye number(25,4) -- 行员余额
    ,hyylj number(25,4) -- 行员月累计
    ,hyjlj number(25,4) -- 行员季累计
    ,hybnlj number(25,4) -- 行员半年累计
    ,hynlj number(25,4) -- 行员年累计
    ,wjfl varchar2(2) -- 五级分类
    ,khdkje number(25,4) -- 客户贷款金额
    ,ftpzycb number(25,4) -- FTP转移成本
    ,ftpzycbylj number(25,4) -- FTP转移成本月累计
    ,ftpzycbjlj number(25,4) -- FTP转移成本季累计
    ,ftpzycbbnlj number(25,4) -- FTP转移成本半年累计
    ,ftpzycbnlj number(25,4) -- FTP转移成本年累计
    ,ftplxsr number(25,4) -- FTP利息收入
    ,ftplxsrylj number(25,4) -- FTP利息收入月累计
    ,ftplxsrjlj number(25,4) -- FTP利息收入季累计
    ,ftplxsrbnlj number(25,4) -- FTP利息收入半年累计
    ,ftplxsrnlj number(25,4) -- FTP利息收入年累计
    ,ftpsy number(25,4) -- FTP收益
    ,ftpsyylj number(25,4) -- FTP收益月累计
    ,ftpsyjlj number(25,4) -- FTP收益季累计
    ,ftpsybnlj number(25,4) -- FTP收益半年累计
    ,ftpsynlj number(25,4) -- FTP收益年累计
    ,hxbz varchar2(2) -- 是否核销标志：0-否，1-是
    ,xwdkbs varchar2(2) -- 小微贷款标识：0-否，1-是
    ,zxzdkztdm varchar2(45) -- 支小再贷款状态代码
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 64k next 64k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.pams_nbzz_dklrmx to ${iml_schema};
grant select on ${iol_schema}.pams_nbzz_dklrmx to ${icl_schema};
grant select on ${iol_schema}.pams_nbzz_dklrmx to ${idl_schema};
grant select on ${iol_schema}.pams_nbzz_dklrmx to ${iel_schema};

-- comment
comment on table ${iol_schema}.pams_nbzz_dklrmx is '贷款利润明细账';
comment on column ${iol_schema}.pams_nbzz_dklrmx.tjrq is '统计日期';
comment on column ${iol_schema}.pams_nbzz_dklrmx.khdxdh is '考核对象代号';
comment on column ${iol_schema}.pams_nbzz_dklrmx.jxdxdh is '绩效对象代号';
comment on column ${iol_schema}.pams_nbzz_dklrmx.jgkhdxdh is '机构考核对象代号';
comment on column ${iol_schema}.pams_nbzz_dklrmx.kmh is '科目号';
comment on column ${iol_schema}.pams_nbzz_dklrmx.cph is '产品号';
comment on column ${iol_schema}.pams_nbzz_dklrmx.ywpz is '业务品种';
comment on column ${iol_schema}.pams_nbzz_dklrmx.fpjs is '分配角色：1-共管，2-管户';
comment on column ${iol_schema}.pams_nbzz_dklrmx.zhdh is '账户代号';
comment on column ${iol_schema}.pams_nbzz_dklrmx.zzh is '子账号';
comment on column ${iol_schema}.pams_nbzz_dklrmx.zhhm is '账户名称';
comment on column ${iol_schema}.pams_nbzz_dklrmx.khh is '客户号';
comment on column ${iol_schema}.pams_nbzz_dklrmx.jgdh is '机构代号';
comment on column ${iol_schema}.pams_nbzz_dklrmx.qx is '期限';
comment on column ${iol_schema}.pams_nbzz_dklrmx.zhbs is '账户标识：1-公司，2-个人';
comment on column ${iol_schema}.pams_nbzz_dklrmx.bz is '币种';
comment on column ${iol_schema}.pams_nbzz_dklrmx.nll is '年利率';
comment on column ${iol_schema}.pams_nbzz_dklrmx.zyjg is '转移价格';
comment on column ${iol_schema}.pams_nbzz_dklrmx.ftplc is 'FTP利差';
comment on column ${iol_schema}.pams_nbzz_dklrmx.zlbl is '增量比例：大于0为当前认领，为0为历史认领';
comment on column ${iol_schema}.pams_nbzz_dklrmx.zhye is '账户余额';
comment on column ${iol_schema}.pams_nbzz_dklrmx.hyye is '行员余额';
comment on column ${iol_schema}.pams_nbzz_dklrmx.hyylj is '行员月累计';
comment on column ${iol_schema}.pams_nbzz_dklrmx.hyjlj is '行员季累计';
comment on column ${iol_schema}.pams_nbzz_dklrmx.hybnlj is '行员半年累计';
comment on column ${iol_schema}.pams_nbzz_dklrmx.hynlj is '行员年累计';
comment on column ${iol_schema}.pams_nbzz_dklrmx.wjfl is '五级分类';
comment on column ${iol_schema}.pams_nbzz_dklrmx.khdkje is '客户贷款金额';
comment on column ${iol_schema}.pams_nbzz_dklrmx.ftpzycb is 'FTP转移成本';
comment on column ${iol_schema}.pams_nbzz_dklrmx.ftpzycbylj is 'FTP转移成本月累计';
comment on column ${iol_schema}.pams_nbzz_dklrmx.ftpzycbjlj is 'FTP转移成本季累计';
comment on column ${iol_schema}.pams_nbzz_dklrmx.ftpzycbbnlj is 'FTP转移成本半年累计';
comment on column ${iol_schema}.pams_nbzz_dklrmx.ftpzycbnlj is 'FTP转移成本年累计';
comment on column ${iol_schema}.pams_nbzz_dklrmx.ftplxsr is 'FTP利息收入';
comment on column ${iol_schema}.pams_nbzz_dklrmx.ftplxsrylj is 'FTP利息收入月累计';
comment on column ${iol_schema}.pams_nbzz_dklrmx.ftplxsrjlj is 'FTP利息收入季累计';
comment on column ${iol_schema}.pams_nbzz_dklrmx.ftplxsrbnlj is 'FTP利息收入半年累计';
comment on column ${iol_schema}.pams_nbzz_dklrmx.ftplxsrnlj is 'FTP利息收入年累计';
comment on column ${iol_schema}.pams_nbzz_dklrmx.ftpsy is 'FTP收益';
comment on column ${iol_schema}.pams_nbzz_dklrmx.ftpsyylj is 'FTP收益月累计';
comment on column ${iol_schema}.pams_nbzz_dklrmx.ftpsyjlj is 'FTP收益季累计';
comment on column ${iol_schema}.pams_nbzz_dklrmx.ftpsybnlj is 'FTP收益半年累计';
comment on column ${iol_schema}.pams_nbzz_dklrmx.ftpsynlj is 'FTP收益年累计';
comment on column ${iol_schema}.pams_nbzz_dklrmx.hxbz is '是否核销标志：0-否，1-是';
comment on column ${iol_schema}.pams_nbzz_dklrmx.xwdkbs is '小微贷款标识：0-否，1-是';
comment on column ${iol_schema}.pams_nbzz_dklrmx.zxzdkztdm is '支小再贷款状态代码';
comment on column ${iol_schema}.pams_nbzz_dklrmx.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.pams_nbzz_dklrmx.etl_timestamp is 'ETL处理时间戳';
