/*
Purpose:    技术缓冲层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py msl msl_edw_pams_jxbb_dkftpmx
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${msl_schema}.msl_edw_pams_jxbb_dkftpmx
whenever sqlerror continue none;
drop table ${msl_schema}.msl_edw_pams_jxbb_dkftpmx purge;

whenever sqlerror exit sql.sqlcode;
create table ${msl_schema}.msl_edw_pams_jxbb_dkftpmx(
    etl_dt date
    ,tjrq number(22)
    ,khm varchar2(300)
    ,khh varchar2(150)
    ,khjgkhdxdh number(22)
    ,khjgh varchar2(150)
    ,khjgmc varchar2(150)
    ,ssjgkhdxdh number(22)
    ,ssjgh varchar2(150)
    ,ssjgmc varchar2(150)
    ,khjlgh varchar2(150)
    ,khjlxm varchar2(150)
    ,fpbl number(19,5)
    ,zhbs varchar2(150)
    ,xwdkbs varchar2(150)
    ,jjh varchar2(150)
    ,jjzt varchar2(150)
    ,dqzxll number(38,8)
    ,jzll number(38,8)
    ,fdbl number(25,4)
    ,fdfs varchar2(150)
    ,kmh varchar2(150)
    ,kmmc varchar2(150)
    ,cpbh varchar2(150)
    ,cpejfl varchar2(150)
    ,cpsjfl varchar2(150)
    ,cpsijfl varchar2(150)
    ,cpzwmc varchar2(150)
    ,sfxw varchar2(150)
    ,qx varchar2(150)
    ,fkr number(22)
    ,dqr number(22)
    ,bz varchar2(150)
    ,ye number(25,4)
    ,yrj number(25,4)
    ,nrj number(25,4)
    ,ylx number(25,4)
    ,nlx number(25,4)
    ,ftpjg number(25,4)
    ,dyftpzycb number(25,4)
    ,ljftpzycb number(25,4)
    ,dyftpjsy number(25,4)
    ,ljftpjsy number(25,4)
    ,ftplxsr number(25,4)
    ,ftpzycb number(25,4)
    ,ftpsy number(25,4)
    ,lxkm varchar2(75)
    ,lxkmmc varchar2(150)
    ,pjh varchar2(60)
    ,wjfl varchar2(8)
    ,yqxyss number(26,5)
    ,jrj number(25,4)
    ,jlx number(25,4)
    ,djftpzycb number(25,4)
    ,djftpjsy number(25,4)
    ,bwbs varchar2(2)
    ,gyljrywbz varchar2(30)
    ,fxjqzcje number(25,4)
    ,fptx varchar2(30)
)
storage (initial 1024k next 1024k)
compress nologging
;

-- grant
grant select on ${msl_schema}.msl_edw_pams_jxbb_dkftpmx to ${itl_schema};

-- comment
comment on table ${msl_schema}.msl_edw_pams_jxbb_dkftpmx is '客户贷款ftp结果表';
comment on column ${msl_schema}.msl_edw_pams_jxbb_dkftpmx.etl_dt is '数据日期';
comment on column ${msl_schema}.msl_edw_pams_jxbb_dkftpmx.tjrq is '统计日期';
comment on column ${msl_schema}.msl_edw_pams_jxbb_dkftpmx.khm is '客户名称';
comment on column ${msl_schema}.msl_edw_pams_jxbb_dkftpmx.khh is '客户号';
comment on column ${msl_schema}.msl_edw_pams_jxbb_dkftpmx.khjgkhdxdh is '开户机构考核对象代号';
comment on column ${msl_schema}.msl_edw_pams_jxbb_dkftpmx.khjgh is '开户机构号';
comment on column ${msl_schema}.msl_edw_pams_jxbb_dkftpmx.khjgmc is '开户机构名称';
comment on column ${msl_schema}.msl_edw_pams_jxbb_dkftpmx.ssjgkhdxdh is '所属机构考核对象代号';
comment on column ${msl_schema}.msl_edw_pams_jxbb_dkftpmx.ssjgh is '所属机构号';
comment on column ${msl_schema}.msl_edw_pams_jxbb_dkftpmx.ssjgmc is '所属机构名称';
comment on column ${msl_schema}.msl_edw_pams_jxbb_dkftpmx.khjlgh is '客户经理工号';
comment on column ${msl_schema}.msl_edw_pams_jxbb_dkftpmx.khjlxm is '客户经理姓名';
comment on column ${msl_schema}.msl_edw_pams_jxbb_dkftpmx.fpbl is '分配比例';
comment on column ${msl_schema}.msl_edw_pams_jxbb_dkftpmx.zhbs is '账户标识';
comment on column ${msl_schema}.msl_edw_pams_jxbb_dkftpmx.xwdkbs is '小微贷款标识';
comment on column ${msl_schema}.msl_edw_pams_jxbb_dkftpmx.jjh is '借据号';
comment on column ${msl_schema}.msl_edw_pams_jxbb_dkftpmx.jjzt is '借据状态';
comment on column ${msl_schema}.msl_edw_pams_jxbb_dkftpmx.dqzxll is '当前执行利率';
comment on column ${msl_schema}.msl_edw_pams_jxbb_dkftpmx.jzll is '基准利率';
comment on column ${msl_schema}.msl_edw_pams_jxbb_dkftpmx.fdbl is '浮动比率';
comment on column ${msl_schema}.msl_edw_pams_jxbb_dkftpmx.fdfs is '浮动方式';
comment on column ${msl_schema}.msl_edw_pams_jxbb_dkftpmx.kmh is '科目号';
comment on column ${msl_schema}.msl_edw_pams_jxbb_dkftpmx.kmmc is '科目名称';
comment on column ${msl_schema}.msl_edw_pams_jxbb_dkftpmx.cpbh is '产品编号';
comment on column ${msl_schema}.msl_edw_pams_jxbb_dkftpmx.cpejfl is '产品二级分类';
comment on column ${msl_schema}.msl_edw_pams_jxbb_dkftpmx.cpsjfl is '产品三级分类';
comment on column ${msl_schema}.msl_edw_pams_jxbb_dkftpmx.cpsijfl is '产品四级分类';
comment on column ${msl_schema}.msl_edw_pams_jxbb_dkftpmx.cpzwmc is '产品中文名称';
comment on column ${msl_schema}.msl_edw_pams_jxbb_dkftpmx.sfxw is '是否小微';
comment on column ${msl_schema}.msl_edw_pams_jxbb_dkftpmx.qx is '期限';
comment on column ${msl_schema}.msl_edw_pams_jxbb_dkftpmx.fkr is '放款日';
comment on column ${msl_schema}.msl_edw_pams_jxbb_dkftpmx.dqr is '到期日';
comment on column ${msl_schema}.msl_edw_pams_jxbb_dkftpmx.bz is '币种';
comment on column ${msl_schema}.msl_edw_pams_jxbb_dkftpmx.ye is '余额';
comment on column ${msl_schema}.msl_edw_pams_jxbb_dkftpmx.yrj is '月日均';
comment on column ${msl_schema}.msl_edw_pams_jxbb_dkftpmx.nrj is '年日均';
comment on column ${msl_schema}.msl_edw_pams_jxbb_dkftpmx.ylx is '月利息';
comment on column ${msl_schema}.msl_edw_pams_jxbb_dkftpmx.nlx is '年利息';
comment on column ${msl_schema}.msl_edw_pams_jxbb_dkftpmx.ftpjg is 'FTP价格';
comment on column ${msl_schema}.msl_edw_pams_jxbb_dkftpmx.dyftpzycb is '当月FTP转移成本';
comment on column ${msl_schema}.msl_edw_pams_jxbb_dkftpmx.ljftpzycb is '累计FTP转移成本';
comment on column ${msl_schema}.msl_edw_pams_jxbb_dkftpmx.dyftpjsy is '当月FTP净收益';
comment on column ${msl_schema}.msl_edw_pams_jxbb_dkftpmx.ljftpjsy is '累计FTP净收益';
comment on column ${msl_schema}.msl_edw_pams_jxbb_dkftpmx.ftplxsr is 'FTP利息收入';
comment on column ${msl_schema}.msl_edw_pams_jxbb_dkftpmx.ftpzycb is 'FTP转移成本';
comment on column ${msl_schema}.msl_edw_pams_jxbb_dkftpmx.ftpsy is 'FTP净收益';
comment on column ${msl_schema}.msl_edw_pams_jxbb_dkftpmx.lxkm is '利息科目号';
comment on column ${msl_schema}.msl_edw_pams_jxbb_dkftpmx.lxkmmc is '利息科目名称';
comment on column ${msl_schema}.msl_edw_pams_jxbb_dkftpmx.pjh is '票据号';
comment on column ${msl_schema}.msl_edw_pams_jxbb_dkftpmx.wjfl is '五级分类';
comment on column ${msl_schema}.msl_edw_pams_jxbb_dkftpmx.yqxyss is '预期信用损失';
comment on column ${msl_schema}.msl_edw_pams_jxbb_dkftpmx.jrj is '季日均';
comment on column ${msl_schema}.msl_edw_pams_jxbb_dkftpmx.jlx is '季利息';
comment on column ${msl_schema}.msl_edw_pams_jxbb_dkftpmx.djftpzycb is '当季ftp转移成本';
comment on column ${msl_schema}.msl_edw_pams_jxbb_dkftpmx.djftpjsy is '当季ftp净收益';
comment on column ${msl_schema}.msl_edw_pams_jxbb_dkftpmx.bwbs is '表外业务标志';
comment on column ${msl_schema}.msl_edw_pams_jxbb_dkftpmx.gyljrywbz is '供应链标志';
comment on column ${msl_schema}.msl_edw_pams_jxbb_dkftpmx.fxjqzcje is '风险加权资产金额';
comment on column ${msl_schema}.msl_edw_pams_jxbb_dkftpmx.fptx is '分配条线';
