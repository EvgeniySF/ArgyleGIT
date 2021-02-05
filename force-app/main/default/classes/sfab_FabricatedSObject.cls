/*
MIT License

Copyright (c) 2017 Matt Addy

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/
public virtual class sfab_FabricatedSObject {
    private Type sType;
    @testVisible private List<sfab_FabricatedSObjectNode> nodes = new List<sfab_FabricatedSObjectNode>();

    public sfab_FabricatedSObject(Type sType) {
        this.sType = sType;
    }

    public sfab_FabricatedSObject(Type sType, Map<Schema.SObjectField, Object> fields) {
        this(sType);

        for (Schema.SObjectField field : fields.keySet()) {
            setField(field, fields.get(field));
        }
    }

    @testVisible protected sfab_FabricatedSObject(Type sType, List<sfab_FabricatedSObjectNode> nodes) {
        this.sType = sType;
        this.nodes = nodes;
    }

    public sfab_FabricatedSObject setField(Schema.SObjectField field, Object value) {
        nodes.add(new sfab_FieldValuePairNode(field, value));
        return this;
    }

    public sfab_FabricatedSObject setParent(String relationshipName, sfab_FabricatedSObject fabricatedParent) {
        nodes.add(new sfab_ParentRelationshipNode(relationshipName, fabricatedParent));
        return this;
    }

    public sfab_FabricatedSObject setChildren(String relationshipName, List<sfab_FabricatedSObject> fabricatedChildren) {
        nodes.add(new sfab_ChildRelationshipNode(relationshipName, fabricatedChildren));
        return this;
    }

    public SObject toSObject() {
        return (SObject)JSON.deserialize(JSON.serialize(serialize()), sType);
    }

    public virtual Map<String, Object> serialize() {
        Map<String, Object> fields = new Map<String, Object>();

        for (sfab_FabricatedSObjectNode node : nodes) {
            fields.putAll(node.serialize());
        }

        return fields;
    }
}