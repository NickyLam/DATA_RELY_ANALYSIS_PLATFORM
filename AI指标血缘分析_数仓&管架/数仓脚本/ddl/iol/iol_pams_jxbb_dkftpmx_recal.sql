/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol pams_jxbb_dkftpmx_recal
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.pams_jxbb_dkftpmx_recal
whenever sqlerror continue none;
drop table ${iol_schema}.pams_jxbb_dkftpmx_recal purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_jxbb_dkftpmx_recal(
    tjrq number(22) -- 统计日期
    ,khm varchar2(600) -- 客户名
    ,khh varchar2(300) -- 客户号
    ,khjgkhdxdh number(22) -- 开户机构考核对象代号
    ,khjgh varchar2(300) -- 开户机构号
    ,khjgmc varchar2(300) -- 开户机构名称
    ,ssjgkhdxdh number(22) -- 所属机构考核对象代号
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
    ,fkr number(22) -- 放款日
    ,dqr number(22) -- 到期日期
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
    ,wjfl varchar2(15) -- 五级分类
    ,pjh varchar2(120) -- 票据号
    ,yqxyss number(26,5) -- 预计信用损失
    ,fxjqzcje number(25,4) -- 风险加权资产金额
    ,bzdm varchar2(30) -- 币种代码
    ,jrj number(25,4) -- 季日均
    ,jlx number(25,4) -- 季利息
    ,djftpzycb number(25,4) -- 当季FTP转移成本
    ,djftpjsy number(25,4) -- 当季FTP净收益
    ,fptx varchar2(30) -- 分配条线
    ,txfpbl number(19,5) -- 条线分配比例
    ,bwbs varchar2(3) -- 表外标识
    ,gyljrywbz varchar2(30) -- 供应链金融业务标志
    ,recal_dt number(22) -- 重算日期
    ,ljtzysje number(25,4) -- 累计调整营收金额
    ,tzhljftpjsy number(25,4) -- 调整后累计ftp净收益
    ,ljtzfyje number(25,4) -- 累计调整费用金额
    ,jjljftpjsy number(25,4) -- 计奖累计ftp净收益
    ,dytzysje number(25,4) -- 月累计调整营收金额
    ,tzhdyftpjsy number(25,4) -- 调整后月累计FTP净收益
    ,dytzfyje number(25,4) -- 月累计调整费用金额
    ,jjdyftpjsy number(25,4) -- 计奖月累计FTP净收益
    ,xbcxdbs varchar2(30) -- 1+N信保贷标识
    ,zcpbh varchar2(180) -- 子产品编号
    ,zcpmc varchar2(750) -- 子产品名称
    ,dkje number(25,4) -- 放款金额
    ,bjyqts number(22) -- 逾期天数
    ,dkfflb varchar2(90) -- 贷款发放类型
    ,nsxl number(25,4) -- 当年收息率
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
grant select on ${iol_schema}.pams_jxbb_dkftpmx_recal to ${iml_schema};
grant select on ${iol_schema}.pams_jxbb_dkftpmx_recal to ${icl_schema};
grant select on ${iol_schema}.pams_jxbb_dkftpmx_recal to ${idl_schema};
grant select on ${iol_schema}.pams_jxbb_dkftpmx_recal to ${iel_schema};

-- comment
comment on table ${iol_schema}.pams_jxbb_dkftpmx_recal is '客户贷款ftp结果表_重算';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_recal.tjrq is '统计日期';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_recal.khm is '客户名';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_recal.khh is '客户号';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_recal.khjgkhdxdh is '开户机构考核对象代号';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_recal.khjgh is '开户机构号';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_recal.khjgmc is '开户机构名称';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_recal.ssjgkhdxdh is '所属机构考核对象代号';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_recal.ssjgh is '所属机构号';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_recal.ssjgmc is '所属机构名称';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_recal.khjlgh is '客户经理工号';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_recal.khjlxm is '客户经理名称';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_recal.fpbl is '分配比例';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_recal.zhbs is '账户标识';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_recal.xwdkbs is '小微贷款标识';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_recal.jjh is '借据号';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_recal.jjzt is '借据状态';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_recal.dqzxll is '当前执行利率';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_recal.jzll is '基准利率';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_recal.fdbl is '浮动比率';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_recal.fdfs is '浮动方式';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_recal.kmh is '科目号';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_recal.kmmc is '科目名称';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_recal.cpbh is '产品编号';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_recal.cpejfl is '产品二级分类';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_recal.cpsjfl is '产品四级分类';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_recal.cpsijfl is '产品四级分类';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_recal.cpzwmc is '产品中文名称';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_recal.sfxw is '是否小微';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_recal.qx is '期限';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_recal.fkr is '放款日';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_recal.dqr is '到期日期';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_recal.bz is '币种';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_recal.ye is '余额';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_recal.yrj is '月日均';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_recal.nrj is '年日均';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_recal.ylx is '月利息';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_recal.nlx is '年利息';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_recal.ftpjg is 'FTP价格';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_recal.dyftpzycb is '当月FTP转移成本';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_recal.ljftpzycb is '累计FTP转移成本';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_recal.dyftpjsy is '当月FTP净收益';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_recal.ljftpjsy is '累计FTP净收益';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_recal.ftplxsr is 'FTP利息收入';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_recal.ftpzycb is 'FTP转移成本';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_recal.ftpsy is 'FTP收益';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_recal.lxkm is '利息科目';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_recal.lxkmmc is '利息科目名称';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_recal.wjfl is '五级分类';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_recal.pjh is '票据号';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_recal.yqxyss is '预计信用损失';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_recal.fxjqzcje is '风险加权资产金额';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_recal.bzdm is '币种代码';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_recal.jrj is '季日均';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_recal.jlx is '季利息';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_recal.djftpzycb is '当季FTP转移成本';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_recal.djftpjsy is '当季FTP净收益';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_recal.fptx is '分配条线';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_recal.txfpbl is '条线分配比例';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_recal.bwbs is '表外标识';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_recal.gyljrywbz is '供应链金融业务标志';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_recal.recal_dt is '重算日期';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_recal.ljtzysje is '累计调整营收金额';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_recal.tzhljftpjsy is '调整后累计ftp净收益';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_recal.ljtzfyje is '累计调整费用金额';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_recal.jjljftpjsy is '计奖累计ftp净收益';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_recal.dytzysje is '月累计调整营收金额';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_recal.tzhdyftpjsy is '调整后月累计FTP净收益';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_recal.dytzfyje is '月累计调整费用金额';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_recal.jjdyftpjsy is '计奖月累计FTP净收益';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_recal.xbcxdbs is '1+N信保贷标识';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_recal.zcpbh is '子产品编号';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_recal.zcpmc is '子产品名称';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_recal.dkje is '放款金额';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_recal.bjyqts is '逾期天数';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_recal.dkfflb is '贷款发放类型';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_recal.nsxl is '当年收息率';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_recal.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_recal.etl_timestamp is 'ETL处理时间戳';
