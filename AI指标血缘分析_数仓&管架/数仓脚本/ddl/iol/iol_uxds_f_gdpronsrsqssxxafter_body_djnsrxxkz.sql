/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol uxds_f_gdpronsrsqssxxafter_body_djnsrxxkz
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.uxds_f_gdpronsrsqssxxafter_body_djnsrxxkz
whenever sqlerror continue none;
drop table ${iol_schema}.uxds_f_gdpronsrsqssxxafter_body_djnsrxxkz purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.uxds_f_gdpronsrsqssxxafter_body_djnsrxxkz(
    gendate date -- 生成时间
    ,serialnumber varchar2(4000) -- 业务系统流水号
    ,sequenceid varchar2(4000) -- 系统流水号
    ,djnsrxxkz varchar2(4000) -- 关联标签
    ,swdlrlxdh varchar2(4000) -- 税务代理人联系电话
    ,cwfzrsfzjhm varchar2(4000) -- 财务负责人身份证件号码
    ,zfjglxmc varchar2(4000) -- 总分机构类型名称
    ,gykglx_dm varchar2(4000) -- 总分机构类型名称
    ,scjydlxdh varchar2(4000) -- 生产经营地联系电话
    ,cwfzryddh varchar2(4000) -- 财务负责人移动电话
    ,zfjglx_dm varchar2(4000) -- 总分机构类型代码
    ,zzsqylxmc varchar2(4000) -- 增值税企业类型名称
    ,zcdyzbm varchar2(4000) -- 注册地邮政编码
    ,fddbryddh varchar2(4000) -- 法定代表人移动电话
    ,swdlrdzxx varchar2(4000) -- 税务代理人电子信箱
    ,ggrs varchar2(4000) -- 雇工人数
    ,cwfzrsfzjzlmc varchar2(4000) -- 财务负责人身份证件种类名称
    ,hjszd varchar2(4000) -- 户籍所在地
    ,cyrs varchar2(4000) -- 从业人数
    ,gykglxmc varchar2(4000) -- 国有控股类型名称
    ,cwfzrxm varchar2(4000) -- 财务负责人姓名
    ,bsrsfzjhm varchar2(4000) -- 办税人身份证件号码
    ,bzfsmc varchar2(4000) -- 办证方式名称
    ,gdgrs varchar2(4000) -- 固定工人数
    ,bsrsfzjzl_dm varchar2(4000) -- 办税人身份证件种类代码
    ,cwfzrdzxx varchar2(4000) -- 财务负责人电子信箱
    ,wjcyrs varchar2(4000) -- 外籍从业人数
    ,zzsqylx_dm varchar2(4000) -- 增值税企业类型代码
    ,tzze varchar2(4000) -- 投资总额
    ,cwfzrsfzjzl_dm varchar2(4000) -- 财务负责人身份证件种类代码
    ,scjydyzbm varchar2(4000) -- 生产经营地邮政编码
    ,jyfw varchar2(4000) -- 经营范围
    ,bsrdzxx varchar2(4000) -- 办税人电子信箱
    ,gjhdqsz_dm varchar2(4000) -- 国家或地区数字代码
    ,kjzdzzmc varchar2(4000) -- 会计制度（准则）名称
    ,zczb varchar2(4000) -- 注册资本
    ,cwfzrgddh varchar2(4000) -- 财务负责人固定电话
    ,bsryddh varchar2(4000) -- 办税人移动电话
    ,ygznsrlx_dm varchar2(4000) -- 营改增纳税人类型代码
    ,zzjglxmc varchar2(4000) -- 组织机构类型名称
    ,zzjglx_dm varchar2(4000) -- 组织机构类型代码
    ,bsrgddh varchar2(4000) -- 办税人固定电话
    ,ygznsrlxmc varchar2(4000) -- 营改增纳税人类型名称
    ,bsrxm varchar2(4000) -- 办税人姓名
    ,zzsjylb varchar2(4000) -- 增值税经营类别
    ,swdlrmc varchar2(4000) -- 税务代理人名称
    ,djxh varchar2(4000) -- 登记序号
    ,hsfs_dm varchar2(4000) -- 核算方式代码
    ,bzfs_dm varchar2(4000) -- 办证方式代码
    ,bsrsfzjzlmc varchar2(4000) -- 办税人身份证件种类名称
    ,gjhdqszmc varchar2(4000) -- 国家或地区数字名称
    ,zrrtzbl varchar2(4000) -- 自然人投资比例
    ,fddbrdzxx varchar2(4000) -- 法定代表人电子信箱
    ,hhrs varchar2(4000) -- 合伙人数
    ,wztzbl varchar2(4000) -- 外资投资比例
    ,kjzdzz_dm varchar2(4000) -- 会计制度（准则）代码
    ,zcdlxdh varchar2(4000) -- 注册地联系电话
    ,hsfsmc varchar2(4000) -- 核算方式名称
    ,gytzbl varchar2(4000) -- 国有投资比例
    ,fddbrgddh varchar2(4000) -- 法定代表人固定电话
    ,swdlrnsrsbh varchar2(4000) -- 税务代理人纳税人识别号
    ,genmonth varchar2(4000) -- 
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
grant select on ${iol_schema}.uxds_f_gdpronsrsqssxxafter_body_djnsrxxkz to ${iml_schema};
grant select on ${iol_schema}.uxds_f_gdpronsrsqssxxafter_body_djnsrxxkz to ${icl_schema};
grant select on ${iol_schema}.uxds_f_gdpronsrsqssxxafter_body_djnsrxxkz to ${idl_schema};
grant select on ${iol_schema}.uxds_f_gdpronsrsqssxxafter_body_djnsrxxkz to ${iel_schema};

-- comment
comment on table ${iol_schema}.uxds_f_gdpronsrsqssxxafter_body_djnsrxxkz is 'gdProNsrSqssxxAfter_body_DJNSRXXKZ';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxxafter_body_djnsrxxkz.gendate is '生成时间';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxxafter_body_djnsrxxkz.serialnumber is '业务系统流水号';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxxafter_body_djnsrxxkz.sequenceid is '系统流水号';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxxafter_body_djnsrxxkz.djnsrxxkz is '关联标签';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxxafter_body_djnsrxxkz.swdlrlxdh is '税务代理人联系电话';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxxafter_body_djnsrxxkz.cwfzrsfzjhm is '财务负责人身份证件号码';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxxafter_body_djnsrxxkz.zfjglxmc is '总分机构类型名称';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxxafter_body_djnsrxxkz.gykglx_dm is '总分机构类型名称';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxxafter_body_djnsrxxkz.scjydlxdh is '生产经营地联系电话';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxxafter_body_djnsrxxkz.cwfzryddh is '财务负责人移动电话';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxxafter_body_djnsrxxkz.zfjglx_dm is '总分机构类型代码';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxxafter_body_djnsrxxkz.zzsqylxmc is '增值税企业类型名称';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxxafter_body_djnsrxxkz.zcdyzbm is '注册地邮政编码';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxxafter_body_djnsrxxkz.fddbryddh is '法定代表人移动电话';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxxafter_body_djnsrxxkz.swdlrdzxx is '税务代理人电子信箱';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxxafter_body_djnsrxxkz.ggrs is '雇工人数';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxxafter_body_djnsrxxkz.cwfzrsfzjzlmc is '财务负责人身份证件种类名称';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxxafter_body_djnsrxxkz.hjszd is '户籍所在地';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxxafter_body_djnsrxxkz.cyrs is '从业人数';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxxafter_body_djnsrxxkz.gykglxmc is '国有控股类型名称';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxxafter_body_djnsrxxkz.cwfzrxm is '财务负责人姓名';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxxafter_body_djnsrxxkz.bsrsfzjhm is '办税人身份证件号码';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxxafter_body_djnsrxxkz.bzfsmc is '办证方式名称';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxxafter_body_djnsrxxkz.gdgrs is '固定工人数';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxxafter_body_djnsrxxkz.bsrsfzjzl_dm is '办税人身份证件种类代码';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxxafter_body_djnsrxxkz.cwfzrdzxx is '财务负责人电子信箱';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxxafter_body_djnsrxxkz.wjcyrs is '外籍从业人数';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxxafter_body_djnsrxxkz.zzsqylx_dm is '增值税企业类型代码';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxxafter_body_djnsrxxkz.tzze is '投资总额';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxxafter_body_djnsrxxkz.cwfzrsfzjzl_dm is '财务负责人身份证件种类代码';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxxafter_body_djnsrxxkz.scjydyzbm is '生产经营地邮政编码';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxxafter_body_djnsrxxkz.jyfw is '经营范围';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxxafter_body_djnsrxxkz.bsrdzxx is '办税人电子信箱';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxxafter_body_djnsrxxkz.gjhdqsz_dm is '国家或地区数字代码';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxxafter_body_djnsrxxkz.kjzdzzmc is '会计制度（准则）名称';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxxafter_body_djnsrxxkz.zczb is '注册资本';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxxafter_body_djnsrxxkz.cwfzrgddh is '财务负责人固定电话';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxxafter_body_djnsrxxkz.bsryddh is '办税人移动电话';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxxafter_body_djnsrxxkz.ygznsrlx_dm is '营改增纳税人类型代码';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxxafter_body_djnsrxxkz.zzjglxmc is '组织机构类型名称';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxxafter_body_djnsrxxkz.zzjglx_dm is '组织机构类型代码';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxxafter_body_djnsrxxkz.bsrgddh is '办税人固定电话';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxxafter_body_djnsrxxkz.ygznsrlxmc is '营改增纳税人类型名称';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxxafter_body_djnsrxxkz.bsrxm is '办税人姓名';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxxafter_body_djnsrxxkz.zzsjylb is '增值税经营类别';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxxafter_body_djnsrxxkz.swdlrmc is '税务代理人名称';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxxafter_body_djnsrxxkz.djxh is '登记序号';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxxafter_body_djnsrxxkz.hsfs_dm is '核算方式代码';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxxafter_body_djnsrxxkz.bzfs_dm is '办证方式代码';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxxafter_body_djnsrxxkz.bsrsfzjzlmc is '办税人身份证件种类名称';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxxafter_body_djnsrxxkz.gjhdqszmc is '国家或地区数字名称';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxxafter_body_djnsrxxkz.zrrtzbl is '自然人投资比例';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxxafter_body_djnsrxxkz.fddbrdzxx is '法定代表人电子信箱';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxxafter_body_djnsrxxkz.hhrs is '合伙人数';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxxafter_body_djnsrxxkz.wztzbl is '外资投资比例';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxxafter_body_djnsrxxkz.kjzdzz_dm is '会计制度（准则）代码';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxxafter_body_djnsrxxkz.zcdlxdh is '注册地联系电话';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxxafter_body_djnsrxxkz.hsfsmc is '核算方式名称';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxxafter_body_djnsrxxkz.gytzbl is '国有投资比例';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxxafter_body_djnsrxxkz.fddbrgddh is '法定代表人固定电话';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxxafter_body_djnsrxxkz.swdlrnsrsbh is '税务代理人纳税人识别号';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxxafter_body_djnsrxxkz.genmonth is '';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxxafter_body_djnsrxxkz.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxxafter_body_djnsrxxkz.etl_timestamp is 'ETL处理时间戳';
