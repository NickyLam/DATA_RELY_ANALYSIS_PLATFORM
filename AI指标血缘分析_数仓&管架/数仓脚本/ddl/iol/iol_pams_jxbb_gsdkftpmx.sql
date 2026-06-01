/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol pams_jxbb_gsdkftpmx
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.pams_jxbb_gsdkftpmx
whenever sqlerror continue none;
drop table ${iol_schema}.pams_jxbb_gsdkftpmx purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_jxbb_gsdkftpmx(
    tjrq number -- 统计日期
    ,khm varchar2(300) -- 客户名
    ,khh varchar2(300) -- 客户号
    ,khjgkhdxdh number -- 开户机构考核对象代号
    ,khjgh varchar2(300) -- 开户机构号
    ,khjgmc varchar2(300) -- 开户机构名称
    ,ssjgkhdxdh number -- 所属机构考核对象代号
    ,ssjgh varchar2(300) -- 所属机构号
    ,ssjgmc varchar2(300) -- 所属机构名称
    ,khjlgh varchar2(300) -- 客户经理工号
    ,khjlxm varchar2(300) -- 客户经理名称
    ,fpbl number(19,5) -- 分配比例
    ,zhbs varchar2(300) -- 账户标识
    ,xwdkbs varchar2(300) -- 小微贷款标识
    ,jjh varchar2(300) -- 借据号
    ,jjzt varchar2(300) -- 借据状态
    ,dqzxll number(38,8) -- 当前执行利率
    ,jzll number(38,8) -- 基准利率
    ,fdbl number(25,4) -- 浮动比率
    ,fdfs varchar2(300) -- 浮动方式
    ,kmh varchar2(300) -- 科目号
    ,kmmc varchar2(300) -- 科目名称
    ,cpbh varchar2(300) -- 产品编号
    ,cpejfl varchar2(300) -- 产品二级分类
    ,cpsjfl varchar2(300) -- 产品四级分类
    ,cpsijfl varchar2(300) -- 产品四级分类
    ,cpzwmc varchar2(300) -- 产品中文名称
    ,sfxw varchar2(300) -- 是否小微
    ,qx varchar2(300) -- 期限
    ,fkr number -- 放款日
    ,dqr number -- 到期日期
    ,bz varchar2(300) -- 币种
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
    ,ftpsy number(25,4) -- FTP收益
    ,lxkm varchar2(150) -- 利息科目
    ,lxkmmc varchar2(300) -- 利息科目名称
    ,pjh varchar2(120) -- 票据号
    ,wjfl varchar2(15) -- 五级分类
    ,yqxyss number(26,5) -- 预计信用损失
    ,fxjqzcje number(25,4) -- 风险加权资产金额
    ,bzdm varchar2(30) -- 币种代码
    ,bwbs varchar2(600) -- 表外标识
    ,cdd varchar2(30) -- 超短贷标志
    ,xgfxjqzcje number(30,2) -- 新规风险资产加权金额
    ,gyljrywbz varchar2(30) -- 供应链金融业务标志
    ,yhycbz varchar2(4000) -- 一行一策标志
    ,tjpdkbz varchar2(3000) -- 碳减排贷款标志
    ,djftpjsy number(25,4) -- 当季FTP净收益
    ,kjds varchar2(12) -- 
    ,dgtx varchar2(12) -- 
    ,jrj number(25,4) -- 季日均
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
grant select on ${iol_schema}.pams_jxbb_gsdkftpmx to ${iml_schema};
grant select on ${iol_schema}.pams_jxbb_gsdkftpmx to ${icl_schema};
grant select on ${iol_schema}.pams_jxbb_gsdkftpmx to ${idl_schema};
grant select on ${iol_schema}.pams_jxbb_gsdkftpmx to ${iel_schema};

-- comment
comment on table ${iol_schema}.pams_jxbb_gsdkftpmx is '绩效报表_对公贷款ftp明细';
comment on column ${iol_schema}.pams_jxbb_gsdkftpmx.tjrq is '统计日期';
comment on column ${iol_schema}.pams_jxbb_gsdkftpmx.khm is '客户名';
comment on column ${iol_schema}.pams_jxbb_gsdkftpmx.khh is '客户号';
comment on column ${iol_schema}.pams_jxbb_gsdkftpmx.khjgkhdxdh is '开户机构考核对象代号';
comment on column ${iol_schema}.pams_jxbb_gsdkftpmx.khjgh is '开户机构号';
comment on column ${iol_schema}.pams_jxbb_gsdkftpmx.khjgmc is '开户机构名称';
comment on column ${iol_schema}.pams_jxbb_gsdkftpmx.ssjgkhdxdh is '所属机构考核对象代号';
comment on column ${iol_schema}.pams_jxbb_gsdkftpmx.ssjgh is '所属机构号';
comment on column ${iol_schema}.pams_jxbb_gsdkftpmx.ssjgmc is '所属机构名称';
comment on column ${iol_schema}.pams_jxbb_gsdkftpmx.khjlgh is '客户经理工号';
comment on column ${iol_schema}.pams_jxbb_gsdkftpmx.khjlxm is '客户经理名称';
comment on column ${iol_schema}.pams_jxbb_gsdkftpmx.fpbl is '分配比例';
comment on column ${iol_schema}.pams_jxbb_gsdkftpmx.zhbs is '账户标识';
comment on column ${iol_schema}.pams_jxbb_gsdkftpmx.xwdkbs is '小微贷款标识';
comment on column ${iol_schema}.pams_jxbb_gsdkftpmx.jjh is '借据号';
comment on column ${iol_schema}.pams_jxbb_gsdkftpmx.jjzt is '借据状态';
comment on column ${iol_schema}.pams_jxbb_gsdkftpmx.dqzxll is '当前执行利率';
comment on column ${iol_schema}.pams_jxbb_gsdkftpmx.jzll is '基准利率';
comment on column ${iol_schema}.pams_jxbb_gsdkftpmx.fdbl is '浮动比率';
comment on column ${iol_schema}.pams_jxbb_gsdkftpmx.fdfs is '浮动方式';
comment on column ${iol_schema}.pams_jxbb_gsdkftpmx.kmh is '科目号';
comment on column ${iol_schema}.pams_jxbb_gsdkftpmx.kmmc is '科目名称';
comment on column ${iol_schema}.pams_jxbb_gsdkftpmx.cpbh is '产品编号';
comment on column ${iol_schema}.pams_jxbb_gsdkftpmx.cpejfl is '产品二级分类';
comment on column ${iol_schema}.pams_jxbb_gsdkftpmx.cpsjfl is '产品四级分类';
comment on column ${iol_schema}.pams_jxbb_gsdkftpmx.cpsijfl is '产品四级分类';
comment on column ${iol_schema}.pams_jxbb_gsdkftpmx.cpzwmc is '产品中文名称';
comment on column ${iol_schema}.pams_jxbb_gsdkftpmx.sfxw is '是否小微';
comment on column ${iol_schema}.pams_jxbb_gsdkftpmx.qx is '期限';
comment on column ${iol_schema}.pams_jxbb_gsdkftpmx.fkr is '放款日';
comment on column ${iol_schema}.pams_jxbb_gsdkftpmx.dqr is '到期日期';
comment on column ${iol_schema}.pams_jxbb_gsdkftpmx.bz is '币种';
comment on column ${iol_schema}.pams_jxbb_gsdkftpmx.ye is '余额';
comment on column ${iol_schema}.pams_jxbb_gsdkftpmx.yrj is '月日均';
comment on column ${iol_schema}.pams_jxbb_gsdkftpmx.nrj is '年日均';
comment on column ${iol_schema}.pams_jxbb_gsdkftpmx.ylx is '月利息';
comment on column ${iol_schema}.pams_jxbb_gsdkftpmx.nlx is '年利息';
comment on column ${iol_schema}.pams_jxbb_gsdkftpmx.ftpjg is 'FTP价格';
comment on column ${iol_schema}.pams_jxbb_gsdkftpmx.dyftpzycb is '当月FTP转移成本';
comment on column ${iol_schema}.pams_jxbb_gsdkftpmx.ljftpzycb is '累计FTP转移成本';
comment on column ${iol_schema}.pams_jxbb_gsdkftpmx.dyftpjsy is '当月FTP净收益';
comment on column ${iol_schema}.pams_jxbb_gsdkftpmx.ljftpjsy is '累计FTP净收益';
comment on column ${iol_schema}.pams_jxbb_gsdkftpmx.ftplxsr is 'FTP利息收入';
comment on column ${iol_schema}.pams_jxbb_gsdkftpmx.ftpzycb is 'FTP转移成本';
comment on column ${iol_schema}.pams_jxbb_gsdkftpmx.ftpsy is 'FTP收益';
comment on column ${iol_schema}.pams_jxbb_gsdkftpmx.lxkm is '利息科目';
comment on column ${iol_schema}.pams_jxbb_gsdkftpmx.lxkmmc is '利息科目名称';
comment on column ${iol_schema}.pams_jxbb_gsdkftpmx.pjh is '票据号';
comment on column ${iol_schema}.pams_jxbb_gsdkftpmx.wjfl is '五级分类';
comment on column ${iol_schema}.pams_jxbb_gsdkftpmx.yqxyss is '预计信用损失';
comment on column ${iol_schema}.pams_jxbb_gsdkftpmx.fxjqzcje is '风险加权资产金额';
comment on column ${iol_schema}.pams_jxbb_gsdkftpmx.bzdm is '币种代码';
comment on column ${iol_schema}.pams_jxbb_gsdkftpmx.bwbs is '表外标识';
comment on column ${iol_schema}.pams_jxbb_gsdkftpmx.cdd is '超短贷标志';
comment on column ${iol_schema}.pams_jxbb_gsdkftpmx.xgfxjqzcje is '新规风险资产加权金额';
comment on column ${iol_schema}.pams_jxbb_gsdkftpmx.gyljrywbz is '供应链金融业务标志';
comment on column ${iol_schema}.pams_jxbb_gsdkftpmx.yhycbz is '一行一策标志';
comment on column ${iol_schema}.pams_jxbb_gsdkftpmx.tjpdkbz is '碳减排贷款标志';
comment on column ${iol_schema}.pams_jxbb_gsdkftpmx.djftpjsy is '当季FTP净收益';
comment on column ${iol_schema}.pams_jxbb_gsdkftpmx.kjds is '';
comment on column ${iol_schema}.pams_jxbb_gsdkftpmx.dgtx is '';
comment on column ${iol_schema}.pams_jxbb_gsdkftpmx.jrj is '季日均';
comment on column ${iol_schema}.pams_jxbb_gsdkftpmx.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.pams_jxbb_gsdkftpmx.etl_timestamp is 'ETL处理时间戳';
