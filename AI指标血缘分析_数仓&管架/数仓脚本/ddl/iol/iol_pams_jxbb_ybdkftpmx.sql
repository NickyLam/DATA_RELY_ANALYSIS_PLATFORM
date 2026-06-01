/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol pams_jxbb_ybdkftpmx
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.pams_jxbb_ybdkftpmx
whenever sqlerror continue none;
drop table ${iol_schema}.pams_jxbb_ybdkftpmx purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_jxbb_ybdkftpmx(
    tjrq number(22,0) -- 统计日期
    ,khm varchar2(150) -- 客户名称
    ,khh varchar2(150) -- 客户号
    ,khjgkhdxdh number(22,0) -- 开户机构考核对象代号
    ,khjgh varchar2(150) -- 开户机构号
    ,khjgmc varchar2(150) -- 开户机构名称
    ,ssjgkhdxdh number(22,0) -- 所属机构考核对象代号
    ,ssjgh varchar2(150) -- 所属机构号
    ,ssjgmc varchar2(150) -- 所属机构名称
    ,khjlgh varchar2(150) -- 客户经理工号
    ,khjlxm varchar2(150) -- 客户经理姓名
    ,fpbl number(19,5) -- 分配比例
    ,zhbs varchar2(150) -- 账户标识
    ,xwdkbs varchar2(150) -- 小微贷款标识
    ,jjh varchar2(150) -- 借据号
    ,jjzt varchar2(150) -- 借据状态
    ,dqzxll number(25,4) -- 当前执行利率
    ,jzll number(25,4) -- 基准利率
    ,fdbl number(25,4) -- 浮动比率
    ,fdfs varchar2(150) -- 浮动方式
    ,kmh varchar2(150) -- 科目号
    ,kmmc varchar2(150) -- 科目名称
    ,cpbh varchar2(150) -- 产品编号
    ,cpejfl varchar2(150) -- 产品二级分类
    ,cpsjfl varchar2(150) -- 产品三级分类
    ,cpsijfl varchar2(150) -- 产品四级分类
    ,cpzwmc varchar2(150) -- 产品中文名称
    ,sfxw varchar2(150) -- 是否小微
    ,qx varchar2(150) -- 期限
    ,fkr number(22,0) -- 放款日
    ,dqr number(22,0) -- 到期日
    ,bz varchar2(150) -- 币种
    ,ye number(25,4) -- 余额
    ,yrj number(25,4) -- 月日均
    ,nrj number(25,4) -- 年日均
    ,ylx number(25,4) -- 月利息
    ,nlx number(25,4) -- 年利息
    ,ftpjg number(25,4) -- FTP价格
    ,dyftpzycb number(25,4) -- 当月FTP转移成本
    ,ljftpzycb number(25,4) -- 累计FTP转移成本
    ,dyftpjsy number(25,4) -- 当月FTP净收益
    ,ljftpjsy number(25,4) -- 累计FTP净收益
    ,ftplxsr number(25,4) -- FTP利息收入
    ,ftpzycb number(25,4) -- FTP转移成本
    ,ftpsy number(25,4) -- FTP净收益
    ,lxkm varchar2(75) -- 利息科目号
    ,lxkmmc varchar2(150) -- 利息科目名称
    ,wjfl varchar2(8) -- 五级分类
    ,pjh varchar2(60) -- 票据号
    ,yqxyss number(26,5) -- 预期信用损失
    ,fxjqzcje number(25,4) -- 风险加权资产金额
    ,bzdm varchar2(15) -- 币种码值
    ,ljtzysje number(25,4) -- 累计调整营收金额
    ,tzhljftpjsy number(25,4) -- 调整后累计ftp净收益
    ,ljtzfyje number(25,4) -- 累计调整费用金额
    ,jjljftpjsy number(25,4) -- 计奖累计ftp净收益
    ,dytzysje number(25,4) -- 月累计调整营收金额
    ,tzhdyftpjsy number(25,4) -- 调整后月累计FTP净收益
    ,dytzfyje number(25,4) -- 月累计调整费用金额
    ,jjdyftpjsy number(25,4) -- 计奖月累计FTP净收益
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
grant select on ${iol_schema}.pams_jxbb_ybdkftpmx to ${iml_schema};
grant select on ${iol_schema}.pams_jxbb_ybdkftpmx to ${icl_schema};
grant select on ${iol_schema}.pams_jxbb_ybdkftpmx to ${idl_schema};
grant select on ${iol_schema}.pams_jxbb_ybdkftpmx to ${iel_schema};

-- comment
comment on table ${iol_schema}.pams_jxbb_ybdkftpmx is '原币贷款明细';
comment on column ${iol_schema}.pams_jxbb_ybdkftpmx.tjrq is '统计日期';
comment on column ${iol_schema}.pams_jxbb_ybdkftpmx.khm is '客户名称';
comment on column ${iol_schema}.pams_jxbb_ybdkftpmx.khh is '客户号';
comment on column ${iol_schema}.pams_jxbb_ybdkftpmx.khjgkhdxdh is '开户机构考核对象代号';
comment on column ${iol_schema}.pams_jxbb_ybdkftpmx.khjgh is '开户机构号';
comment on column ${iol_schema}.pams_jxbb_ybdkftpmx.khjgmc is '开户机构名称';
comment on column ${iol_schema}.pams_jxbb_ybdkftpmx.ssjgkhdxdh is '所属机构考核对象代号';
comment on column ${iol_schema}.pams_jxbb_ybdkftpmx.ssjgh is '所属机构号';
comment on column ${iol_schema}.pams_jxbb_ybdkftpmx.ssjgmc is '所属机构名称';
comment on column ${iol_schema}.pams_jxbb_ybdkftpmx.khjlgh is '客户经理工号';
comment on column ${iol_schema}.pams_jxbb_ybdkftpmx.khjlxm is '客户经理姓名';
comment on column ${iol_schema}.pams_jxbb_ybdkftpmx.fpbl is '分配比例';
comment on column ${iol_schema}.pams_jxbb_ybdkftpmx.zhbs is '账户标识';
comment on column ${iol_schema}.pams_jxbb_ybdkftpmx.xwdkbs is '小微贷款标识';
comment on column ${iol_schema}.pams_jxbb_ybdkftpmx.jjh is '借据号';
comment on column ${iol_schema}.pams_jxbb_ybdkftpmx.jjzt is '借据状态';
comment on column ${iol_schema}.pams_jxbb_ybdkftpmx.dqzxll is '当前执行利率';
comment on column ${iol_schema}.pams_jxbb_ybdkftpmx.jzll is '基准利率';
comment on column ${iol_schema}.pams_jxbb_ybdkftpmx.fdbl is '浮动比率';
comment on column ${iol_schema}.pams_jxbb_ybdkftpmx.fdfs is '浮动方式';
comment on column ${iol_schema}.pams_jxbb_ybdkftpmx.kmh is '科目号';
comment on column ${iol_schema}.pams_jxbb_ybdkftpmx.kmmc is '科目名称';
comment on column ${iol_schema}.pams_jxbb_ybdkftpmx.cpbh is '产品编号';
comment on column ${iol_schema}.pams_jxbb_ybdkftpmx.cpejfl is '产品二级分类';
comment on column ${iol_schema}.pams_jxbb_ybdkftpmx.cpsjfl is '产品三级分类';
comment on column ${iol_schema}.pams_jxbb_ybdkftpmx.cpsijfl is '产品四级分类';
comment on column ${iol_schema}.pams_jxbb_ybdkftpmx.cpzwmc is '产品中文名称';
comment on column ${iol_schema}.pams_jxbb_ybdkftpmx.sfxw is '是否小微';
comment on column ${iol_schema}.pams_jxbb_ybdkftpmx.qx is '期限';
comment on column ${iol_schema}.pams_jxbb_ybdkftpmx.fkr is '放款日';
comment on column ${iol_schema}.pams_jxbb_ybdkftpmx.dqr is '到期日';
comment on column ${iol_schema}.pams_jxbb_ybdkftpmx.bz is '币种';
comment on column ${iol_schema}.pams_jxbb_ybdkftpmx.ye is '余额';
comment on column ${iol_schema}.pams_jxbb_ybdkftpmx.yrj is '月日均';
comment on column ${iol_schema}.pams_jxbb_ybdkftpmx.nrj is '年日均';
comment on column ${iol_schema}.pams_jxbb_ybdkftpmx.ylx is '月利息';
comment on column ${iol_schema}.pams_jxbb_ybdkftpmx.nlx is '年利息';
comment on column ${iol_schema}.pams_jxbb_ybdkftpmx.ftpjg is 'FTP价格';
comment on column ${iol_schema}.pams_jxbb_ybdkftpmx.dyftpzycb is '当月FTP转移成本';
comment on column ${iol_schema}.pams_jxbb_ybdkftpmx.ljftpzycb is '累计FTP转移成本';
comment on column ${iol_schema}.pams_jxbb_ybdkftpmx.dyftpjsy is '当月FTP净收益';
comment on column ${iol_schema}.pams_jxbb_ybdkftpmx.ljftpjsy is '累计FTP净收益';
comment on column ${iol_schema}.pams_jxbb_ybdkftpmx.ftplxsr is 'FTP利息收入';
comment on column ${iol_schema}.pams_jxbb_ybdkftpmx.ftpzycb is 'FTP转移成本';
comment on column ${iol_schema}.pams_jxbb_ybdkftpmx.ftpsy is 'FTP净收益';
comment on column ${iol_schema}.pams_jxbb_ybdkftpmx.lxkm is '利息科目号';
comment on column ${iol_schema}.pams_jxbb_ybdkftpmx.lxkmmc is '利息科目名称';
comment on column ${iol_schema}.pams_jxbb_ybdkftpmx.wjfl is '五级分类';
comment on column ${iol_schema}.pams_jxbb_ybdkftpmx.pjh is '票据号';
comment on column ${iol_schema}.pams_jxbb_ybdkftpmx.yqxyss is '预期信用损失';
comment on column ${iol_schema}.pams_jxbb_ybdkftpmx.fxjqzcje is '风险加权资产金额';
comment on column ${iol_schema}.pams_jxbb_ybdkftpmx.bzdm is '币种码值';
comment on column ${iol_schema}.pams_jxbb_ybdkftpmx.ljtzysje is '累计调整营收金额';
comment on column ${iol_schema}.pams_jxbb_ybdkftpmx.tzhljftpjsy is '调整后累计ftp净收益';
comment on column ${iol_schema}.pams_jxbb_ybdkftpmx.ljtzfyje is '累计调整费用金额';
comment on column ${iol_schema}.pams_jxbb_ybdkftpmx.jjljftpjsy is '计奖累计ftp净收益';
comment on column ${iol_schema}.pams_jxbb_ybdkftpmx.dytzysje is '月累计调整营收金额';
comment on column ${iol_schema}.pams_jxbb_ybdkftpmx.tzhdyftpjsy is '调整后月累计FTP净收益';
comment on column ${iol_schema}.pams_jxbb_ybdkftpmx.dytzfyje is '月累计调整费用金额';
comment on column ${iol_schema}.pams_jxbb_ybdkftpmx.jjdyftpjsy is '计奖月累计FTP净收益';
comment on column ${iol_schema}.pams_jxbb_ybdkftpmx.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.pams_jxbb_ybdkftpmx.etl_timestamp is 'ETL处理时间戳';
