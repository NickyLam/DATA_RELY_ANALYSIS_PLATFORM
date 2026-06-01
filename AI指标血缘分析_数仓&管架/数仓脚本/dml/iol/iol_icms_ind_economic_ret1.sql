/*
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_ind_economic_ret1
CreateDate: 20250331
*/

set timing on
-- 1.1 alter parallel
alter session force parallel query parallel 3;
alter session force parallel dml parallel 3;

declare
  v_var    number(3)  :=0;
  v_sql    varchar2(1000);

begin
  for tb in (SELECT TO_CHAR(END_DT, 'yyyymmdd') as end_dt
               FROM (SELECT END_DT,
                            ROW_NUMBER() OVER(PARTITION BY END_DT ORDER BY END_DT) RN
                       FROM icms_ind_economic_bak${batch_date})
              WHERE RN = 1
 ) loop

  select count(partition_name) into v_var
    from user_tab_partitions
   where substr(partition_name,3) = tb.end_dt
     and table_name = upper('icms_ind_economic');

  if v_var <> 0 then
    execute immediate 'alter table icms_ind_economic drop partition p_' || tb.end_dt;
  end if;

    v_sql :='alter table icms_ind_economic add partition p_' || tb.end_dt || ' values(to_date(' || tb.end_dt || ',''yyyymmdd''))';

    execute immediate v_sql;

-- 回插所有数据

insert /*+ append */ into ${iol_schema}.icms_ind_economic (
    serialno -- 流水号
    ,licname -- 企业登记注册类型名称
    ,certtype -- 企业证件类型证件类型（代码：1-组机构代码2-营业执照3-其他）
    ,migtflag -- 迁移标志：crs rcr ilc upl
    ,confirmcompsize -- 我行认定企业规模
    ,taxtype -- 纳税类型1-小规模纳税人2-一般纳税人
    ,taxorganname -- 主管税务机关名称
    ,relation -- 借款人与经营实体的关系
    ,accountingsystem -- 适用会计制度
    ,customername -- 经营者姓名
    ,taxlevel -- 纳税信用等级a，b，c，d
    ,customerid -- 客户编号
    ,legalcertcode -- 经营者证件号码
    ,comptel -- 经营企业电话
    ,landtaxcode -- 地税登记号
    ,shareratio -- 股东占股比例
    ,businessname -- 企业名称
    ,inputuserid -- 登记人
    ,legalcert -- 经营者证件类型
    ,updateuserid -- 更新人
    ,workersnum -- 企业员工人数
    ,regaddres -- 注册地址
    ,realcapital -- 实收资本
    ,lictype -- 企业登记注册类型代码
    ,citnum -- 中征码
    ,bussowner -- 经营场所所有权
    ,telephone -- 联系电话
    ,bussenddate -- 营业执照到期日期
    ,busstime -- 本行业从业时间
    ,bussname -- 个体工商户名称
    ,taxpayerstate -- 纳税人状态名称1-正常2-非正常
    ,relrepyidtype -- 相关还款责任人证件类型
    ,bussregdate -- 营业执照注册日期
    ,formtype -- 组成形式
    ,compzip -- 经营企业地址邮编
    ,relrepyrsplpsntype -- 相关还款责任人类型
    ,compsize -- 企业规模
    ,bussmain -- 经营范围
    ,inputdate -- 登记时间
    ,comestatus -- 来源状态
    ,busilicname -- 企业营业执照类型名称
    ,industry -- 所属行业编号
    ,legalname -- 法定代表人姓名
    ,taxorgancode -- 税务机关代码
    ,regdist -- 企业注册地址行政区划数字代码
    ,busscode -- 个体工商户营业执照代码
    ,ownerprop -- 所有制性质
    ,industryname -- 所属行业名称
    ,compaddr -- 企业地址
    ,totalassets -- 企业总资产总额
    ,loanpassword -- 贷款卡密码
    ,accountingsystemname -- 适用会计制度名称
    ,operreve -- 营业收入(年)
    ,updatedate -- 更新时间
    ,businessid -- 企业编号
    ,bussbank -- 主要结算银行
    ,busilictype -- 企业营业执照类型代码
    ,corporgid -- 法人机构编号
    ,loancode -- 贷款卡号/中征码
    ,relrepyid -- 相关还款责任人核心客户号
    ,establishdate -- 企业成立日期
    ,legalphone -- 法定代表人电话号码
    ,legalemail -- 法定代表人电子邮箱
    ,regcapital -- 注册资本
    ,certcode -- 组织机构代码证号码
    ,relrepyidentype -- 相关还款责任人身份类型
    ,certid -- 证件号
    ,busslegaltype -- 企业控股类型
    ,bussrentend -- 租赁到期日
    ,nationaltaxcode -- 国税登记号
    ,updateorgid -- 更新机构
    ,inputorgid -- 登记机构
    ,industrytype -- 所属行业
    ,isoperatingentinvolvespecialized -- 经营企业是否涉及专精特新
    ,ishightechnologyent -- 是否高新技术企业
    ,istechnologyent -- 是否科技型企业
    ,isscientifictechent -- 是否科创企业
    ,isspecializedgiantent -- 是否专精特新小巨人企业
    ,isspecializedsmallandmident -- 是否专精特新中小企业
    ,istechnologysmallandmident -- 是否科技型中小企业
    ,isindustrysinglechampionent -- 是否制造业单项冠军企业
    ,isnationaltechnologinnovationent -- 是否国家技术创新示范企业
    ,isgarden -- 是否园区贷
    ,regno -- 注册号
    ,offareacode -- 注册地址行政区编号
    ,province -- 所在省份
    ,regcapcur -- 注册资本币种
    ,runstatus -- 经营状态
    ,canceldate -- 注销日期
    ,revokedate -- 吊销日期
    ,address -- 住址
    ,busiscope2 -- 经营(业务)范围及方式
    ,chkyear -- 最后年检年度
    ,cocode -- 国民经济行业代码
    ,coname -- 国民经济行业名称
    ,creditcode -- 证件号码
    ,city -- 市/州/地区
    ,economicid -- 经营实体ID
    ,start_dt -- 开始时间
    ,end_dt -- 结束时间
    ,id_mark -- 增删标志
    ,etl_timestamp -- ETL处理时间戳
)
select
    serialno as serialno -- 流水号
    ,licname as licname -- 企业登记注册类型名称
    ,certtype as certtype -- 企业证件类型证件类型（代码：1-组机构代码2-营业执照3-其他）
    ,migtflag as migtflag -- 迁移标志：crs rcr ilc upl
    ,confirmcompsize as confirmcompsize -- 我行认定企业规模
    ,taxtype as taxtype -- 纳税类型1-小规模纳税人2-一般纳税人
    ,taxorganname as taxorganname -- 主管税务机关名称
    ,relation as relation -- 借款人与经营实体的关系
    ,accountingsystem as accountingsystem -- 适用会计制度
    ,customername as customername -- 经营者姓名
    ,taxlevel as taxlevel -- 纳税信用等级a，b，c，d
    ,customerid as customerid -- 客户编号
    ,legalcertcode as legalcertcode -- 经营者证件号码
    ,comptel as comptel -- 经营企业电话
    ,landtaxcode as landtaxcode -- 地税登记号
    ,shareratio as shareratio -- 股东占股比例
    ,businessname as businessname -- 企业名称
    ,inputuserid as inputuserid -- 登记人
    ,legalcert as legalcert -- 经营者证件类型
    ,updateuserid as updateuserid -- 更新人
    ,workersnum as workersnum -- 企业员工人数
    ,regaddres as regaddres -- 注册地址
    ,realcapital as realcapital -- 实收资本
    ,lictype as lictype -- 企业登记注册类型代码
    ,citnum as citnum -- 中征码
    ,bussowner as bussowner -- 经营场所所有权
    ,telephone as telephone -- 联系电话
    ,bussenddate as bussenddate -- 营业执照到期日期
    ,busstime as busstime -- 本行业从业时间
    ,bussname as bussname -- 个体工商户名称
    ,taxpayerstate as taxpayerstate -- 纳税人状态名称1-正常2-非正常
    ,relrepyidtype as relrepyidtype -- 相关还款责任人证件类型
    ,bussregdate as bussregdate -- 营业执照注册日期
    ,formtype as formtype -- 组成形式
    ,compzip as compzip -- 经营企业地址邮编
    ,relrepyrsplpsntype as relrepyrsplpsntype -- 相关还款责任人类型
    ,compsize as compsize -- 企业规模
    ,bussmain as bussmain -- 经营范围
    ,inputdate as inputdate -- 登记时间
    ,comestatus as comestatus -- 来源状态
    ,busilicname as busilicname -- 企业营业执照类型名称
    ,industry as industry -- 所属行业编号
    ,legalname as legalname -- 法定代表人姓名
    ,taxorgancode as taxorgancode -- 税务机关代码
    ,regdist as regdist -- 企业注册地址行政区划数字代码
    ,busscode as busscode -- 个体工商户营业执照代码
    ,ownerprop as ownerprop -- 所有制性质
    ,industryname as industryname -- 所属行业名称
    ,compaddr as compaddr -- 企业地址
    ,totalassets as totalassets -- 企业总资产总额
    ,loanpassword as loanpassword -- 贷款卡密码
    ,accountingsystemname as accountingsystemname -- 适用会计制度名称
    ,operreve as operreve -- 营业收入(年)
    ,updatedate as updatedate -- 更新时间
    ,businessid as businessid -- 企业编号
    ,bussbank as bussbank -- 主要结算银行
    ,busilictype as busilictype -- 企业营业执照类型代码
    ,corporgid as corporgid -- 法人机构编号
    ,loancode as loancode -- 贷款卡号/中征码
    ,relrepyid as relrepyid -- 相关还款责任人核心客户号
    ,establishdate as establishdate -- 企业成立日期
    ,legalphone as legalphone -- 法定代表人电话号码
    ,legalemail as legalemail -- 法定代表人电子邮箱
    ,regcapital as regcapital -- 注册资本
    ,certcode as certcode -- 组织机构代码证号码
    ,relrepyidentype as relrepyidentype -- 相关还款责任人身份类型
    ,certid as certid -- 证件号
    ,busslegaltype as busslegaltype -- 企业控股类型
    ,bussrentend as bussrentend -- 租赁到期日
    ,nationaltaxcode as nationaltaxcode -- 国税登记号
    ,updateorgid as updateorgid -- 更新机构
    ,inputorgid as inputorgid -- 登记机构
    ,industrytype as industrytype -- 所属行业
    ,isoperatingentinvolvespecialized as isoperatingentinvolvespecialized -- 经营企业是否涉及专精特新
    ,ishightechnologyent as ishightechnologyent -- 是否高新技术企业
    ,istechnologyent as istechnologyent -- 是否科技型企业
    ,isscientifictechent as isscientifictechent -- 是否科创企业
    ,isspecializedgiantent as isspecializedgiantent -- 是否专精特新小巨人企业
    ,isspecializedsmallandmident as isspecializedsmallandmident -- 是否专精特新中小企业
    ,istechnologysmallandmident as istechnologysmallandmident -- 是否科技型中小企业
    ,isindustrysinglechampionent as isindustrysinglechampionent -- 是否制造业单项冠军企业
    ,isnationaltechnologinnovationent as isnationaltechnologinnovationent -- 是否国家技术创新示范企业
    ,' ' as isgarden -- 是否园区贷
    ,' ' as regno -- 注册号
    ,' ' as offareacode -- 注册地址行政区编号
    ,' ' as province -- 所在省份
    ,' ' as regcapcur -- 注册资本币种
    ,' ' as runstatus -- 经营状态
    ,' ' as canceldate -- 注销日期
    ,' ' as revokedate -- 吊销日期
    ,' ' as address -- 住址
    ,' ' as busiscope2 -- 经营(业务)范围及方式
    ,' ' as chkyear -- 最后年检年度
    ,' ' as cocode -- 国民经济行业代码
    ,' ' as coname -- 国民经济行业名称
    ,' ' as creditcode -- 证件号码
    ,' ' as city -- 市/州/地区
    ,' ' as economicid -- 经营实体ID
    ,start_dt as start_dt -- 开始时间
    ,end_dt as end_dt -- 结束时间
    ,id_mark as id_mark -- 增删标志
    ,etl_timestamp as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.icms_ind_economic_bak${batch_date}
where end_dt = to_date(tb.end_dt,'yyyymmdd');

commit;

end loop;
end;
/

