/*
Purpose:    技术缓冲层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py msl msl_edw_pams_jxbb_dkftpmx_recal
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${msl_schema}.msl_edw_pams_jxbb_dkftpmx_recal
whenever sqlerror continue none;
drop table ${msl_schema}.msl_edw_pams_jxbb_dkftpmx_recal purge;

whenever sqlerror exit sql.sqlcode;
create table ${msl_schema}.msl_edw_pams_jxbb_dkftpmx_recal(
    etl_dt date
    ,tjrq number(22)
    ,khm varchar2(600)
    ,khh varchar2(300)
    ,khjgkhdxdh number(22)
    ,khjgh varchar2(300)
    ,khjgmc varchar2(300)
    ,ssjgkhdxdh number(22)
    ,ssjgh varchar2(300)
    ,ssjgmc varchar2(300)
    ,khjlgh varchar2(300)
    ,khjlxm varchar2(300)
    ,fpbl number(19,5)
    ,zhbs varchar2(300)
    ,xwdkbs varchar2(300)
    ,jjh varchar2(300)
    ,jjzt varchar2(300)
    ,dqzxll number(38,8)
    ,jzll number(38,8)
    ,fdbl number(25,4)
    ,fdfs varchar2(300)
    ,kmh varchar2(300)
    ,kmmc varchar2(300)
    ,cpbh varchar2(300)
    ,cpejfl varchar2(300)
    ,cpsjfl varchar2(300)
    ,cpsijfl varchar2(300)
    ,cpzwmc varchar2(300)
    ,sfxw varchar2(300)
    ,qx varchar2(300)
    ,fkr number(22)
    ,dqr number(22)
    ,bz varchar2(300)
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
    ,lxkm varchar2(150)
    ,lxkmmc varchar2(300)
    ,wjfl varchar2(15)
    ,pjh varchar2(120)
    ,yqxyss number(26,5)
    ,fxjqzcje number(25,4)
    ,bzdm varchar2(30)
    ,jrj number(25,4)
    ,jlx number(25,4)
    ,djftpzycb number(25,4)
    ,djftpjsy number(25,4)
    ,fptx varchar2(30)
    ,txfpbl number(19,5)
    ,bwbs varchar2(3)
    ,gyljrywbz varchar2(30)
    ,recal_dt number(22)
    ,ljtzysje number(25,4)
    ,tzhljftpjsy number(25,4)
    ,ljtzfyje number(25,4)
    ,jjljftpjsy number(25,4)
)
storage (initial 1024k next 1024k)
compress nologging
;

-- grant
grant select on ${msl_schema}.msl_edw_pams_jxbb_dkftpmx_recal to ${itl_schema};

-- comment
comment on table ${msl_schema}.msl_edw_pams_jxbb_dkftpmx_recal is '客户贷款ftp结果表_重算';
comment on column ${msl_schema}.msl_edw_pams_jxbb_dkftpmx_recal.etl_dt is '数据日期';
comment on column ${msl_schema}.msl_edw_pams_jxbb_dkftpmx_recal.tjrq is '统计日期';
comment on column ${msl_schema}.msl_edw_pams_jxbb_dkftpmx_recal.khm is '客户名';
comment on column ${msl_schema}.msl_edw_pams_jxbb_dkftpmx_recal.khh is '客户号';
comment on column ${msl_schema}.msl_edw_pams_jxbb_dkftpmx_recal.khjgkhdxdh is '开户机构考核对象代号';
comment on column ${msl_schema}.msl_edw_pams_jxbb_dkftpmx_recal.khjgh is '开户机构号';
comment on column ${msl_schema}.msl_edw_pams_jxbb_dkftpmx_recal.khjgmc is '开户机构名称';
comment on column ${msl_schema}.msl_edw_pams_jxbb_dkftpmx_recal.ssjgkhdxdh is '所属机构考核对象代号';
comment on column ${msl_schema}.msl_edw_pams_jxbb_dkftpmx_recal.ssjgh is '所属机构号';
comment on column ${msl_schema}.msl_edw_pams_jxbb_dkftpmx_recal.ssjgmc is '所属机构名称';
comment on column ${msl_schema}.msl_edw_pams_jxbb_dkftpmx_recal.khjlgh is '客户经理工号';
comment on column ${msl_schema}.msl_edw_pams_jxbb_dkftpmx_recal.khjlxm is '客户经理名称';
comment on column ${msl_schema}.msl_edw_pams_jxbb_dkftpmx_recal.fpbl is '分配比例';
comment on column ${msl_schema}.msl_edw_pams_jxbb_dkftpmx_recal.zhbs is '账户标识';
comment on column ${msl_schema}.msl_edw_pams_jxbb_dkftpmx_recal.xwdkbs is '小微贷款标识';
comment on column ${msl_schema}.msl_edw_pams_jxbb_dkftpmx_recal.jjh is '借据号';
comment on column ${msl_schema}.msl_edw_pams_jxbb_dkftpmx_recal.jjzt is '借据状态';
comment on column ${msl_schema}.msl_edw_pams_jxbb_dkftpmx_recal.dqzxll is '当前执行利率';
comment on column ${msl_schema}.msl_edw_pams_jxbb_dkftpmx_recal.jzll is '基准利率';
comment on column ${msl_schema}.msl_edw_pams_jxbb_dkftpmx_recal.fdbl is '浮动比率';
comment on column ${msl_schema}.msl_edw_pams_jxbb_dkftpmx_recal.fdfs is '浮动方式';
comment on column ${msl_schema}.msl_edw_pams_jxbb_dkftpmx_recal.kmh is '科目号';
comment on column ${msl_schema}.msl_edw_pams_jxbb_dkftpmx_recal.kmmc is '科目名称';
comment on column ${msl_schema}.msl_edw_pams_jxbb_dkftpmx_recal.cpbh is '产品编号';
comment on column ${msl_schema}.msl_edw_pams_jxbb_dkftpmx_recal.cpejfl is '产品二级分类';
comment on column ${msl_schema}.msl_edw_pams_jxbb_dkftpmx_recal.cpsjfl is '产品四级分类';
comment on column ${msl_schema}.msl_edw_pams_jxbb_dkftpmx_recal.cpsijfl is '产品四级分类';
comment on column ${msl_schema}.msl_edw_pams_jxbb_dkftpmx_recal.cpzwmc is '产品中文名称';
comment on column ${msl_schema}.msl_edw_pams_jxbb_dkftpmx_recal.sfxw is '是否小微';
comment on column ${msl_schema}.msl_edw_pams_jxbb_dkftpmx_recal.qx is '期限';
comment on column ${msl_schema}.msl_edw_pams_jxbb_dkftpmx_recal.fkr is '放款日';
comment on column ${msl_schema}.msl_edw_pams_jxbb_dkftpmx_recal.dqr is '到期日期';
comment on column ${msl_schema}.msl_edw_pams_jxbb_dkftpmx_recal.bz is '币种';
comment on column ${msl_schema}.msl_edw_pams_jxbb_dkftpmx_recal.ye is '余额';
comment on column ${msl_schema}.msl_edw_pams_jxbb_dkftpmx_recal.yrj is '月日均';
comment on column ${msl_schema}.msl_edw_pams_jxbb_dkftpmx_recal.nrj is '年日均';
comment on column ${msl_schema}.msl_edw_pams_jxbb_dkftpmx_recal.ylx is '月利息';
comment on column ${msl_schema}.msl_edw_pams_jxbb_dkftpmx_recal.nlx is '年利息';
comment on column ${msl_schema}.msl_edw_pams_jxbb_dkftpmx_recal.ftpjg is 'ftp价格';
comment on column ${msl_schema}.msl_edw_pams_jxbb_dkftpmx_recal.dyftpzycb is '当月ftp转移成本';
comment on column ${msl_schema}.msl_edw_pams_jxbb_dkftpmx_recal.ljftpzycb is '累计ftp转移成本';
comment on column ${msl_schema}.msl_edw_pams_jxbb_dkftpmx_recal.dyftpjsy is '当月ftp净收益';
comment on column ${msl_schema}.msl_edw_pams_jxbb_dkftpmx_recal.ljftpjsy is '累计ftp净收益';
comment on column ${msl_schema}.msl_edw_pams_jxbb_dkftpmx_recal.ftplxsr is 'ftp利息收入';
comment on column ${msl_schema}.msl_edw_pams_jxbb_dkftpmx_recal.ftpzycb is 'ftp转移成本';
comment on column ${msl_schema}.msl_edw_pams_jxbb_dkftpmx_recal.ftpsy is 'ftp收益';
comment on column ${msl_schema}.msl_edw_pams_jxbb_dkftpmx_recal.lxkm is '利息科目';
comment on column ${msl_schema}.msl_edw_pams_jxbb_dkftpmx_recal.lxkmmc is '利息科目名称';
comment on column ${msl_schema}.msl_edw_pams_jxbb_dkftpmx_recal.wjfl is '五级分类';
comment on column ${msl_schema}.msl_edw_pams_jxbb_dkftpmx_recal.pjh is '票据号';
comment on column ${msl_schema}.msl_edw_pams_jxbb_dkftpmx_recal.yqxyss is '预计信用损失';
comment on column ${msl_schema}.msl_edw_pams_jxbb_dkftpmx_recal.fxjqzcje is '风险加权资产金额';
comment on column ${msl_schema}.msl_edw_pams_jxbb_dkftpmx_recal.bzdm is '币种代码';
comment on column ${msl_schema}.msl_edw_pams_jxbb_dkftpmx_recal.jrj is '季日均';
comment on column ${msl_schema}.msl_edw_pams_jxbb_dkftpmx_recal.jlx is '季利息';
comment on column ${msl_schema}.msl_edw_pams_jxbb_dkftpmx_recal.djftpzycb is '当季ftp转移成本';
comment on column ${msl_schema}.msl_edw_pams_jxbb_dkftpmx_recal.djftpjsy is '当季ftp净收益';
comment on column ${msl_schema}.msl_edw_pams_jxbb_dkftpmx_recal.fptx is '分配条线';
comment on column ${msl_schema}.msl_edw_pams_jxbb_dkftpmx_recal.txfpbl is '条线分配比例';
comment on column ${msl_schema}.msl_edw_pams_jxbb_dkftpmx_recal.bwbs is '表外标识';
comment on column ${msl_schema}.msl_edw_pams_jxbb_dkftpmx_recal.gyljrywbz is '供应链金融业务标志';
comment on column ${msl_schema}.msl_edw_pams_jxbb_dkftpmx_recal.recal_dt is '重算日期';
comment on column ${msl_schema}.msl_edw_pams_jxbb_dkftpmx_recal.ljtzysje is '累计调整营收金额';
comment on column ${msl_schema}.msl_edw_pams_jxbb_dkftpmx_recal.tzhljftpjsy is '调整后累计ftp净收益';
comment on column ${msl_schema}.msl_edw_pams_jxbb_dkftpmx_recal.ljtzfyje is '累计调整费用金额';
comment on column ${msl_schema}.msl_edw_pams_jxbb_dkftpmx_recal.jjljftpjsy is '计奖累计ftp净收益';
